# -*- coding: utf-8 -*-
import logging
import os
import pathlib
import sqlite3
import webbrowser

import flask
from flask import jsonify, request

from .utils.message_handler import MessageHandler, SimpleMessage

server_message_handler = MessageHandler(None, None, False)

logger = logging.getLogger(__name__)

try:
    from .database import initialize_database as db_init
except ImportError:

    def db_init(filename: str, db_logger: logging.Logger):
        logger.error("Module Load Error: initialize_database not found.")


DATABASE_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__))).parent / "database"
WEB_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__))).parent / "web"
db_path: str

app = flask.Flask(__name__, static_url_path="", static_folder=str(WEB_DIRECTORY / "dist"))
app.config["DEBUG"] = True
app.config["PORT"] = 8000


@app.route("/", methods=["GET"])
def index():
    if (WEB_DIRECTORY / "dist/index.html").exists():
        with open(str(WEB_DIRECTORY / "dist/index.html")) as f:
            return f.read()
    else:
        with open(str(WEB_DIRECTORY / "notfound.html")) as f:
            return f.read()


@app.route("/api/federate-time", methods=["GET"])
def federate_time():
    db = sqlite3.connect(db_path)
    arr = []
    for row in db.execute("SELECT name, granted, requested FROM Federates"):
        arr.append({"name": row[0], "granted": row[1], "requested": row[2]})
    return jsonify(arr)


@app.route("/api/named-federate-target-name", methods=["GET"])
def named_federate_target_name():
    db = sqlite3.connect(db_path)
    result = db.execute("SELECT value from MetaData WHERE name = 'federates' " "ORDER BY ROWID DESC LIMIT 1").fetchone()
    feds = result[0].split(",")
    return jsonify(feds)


@app.route("/api/publication-data", methods=["GET"])
def publication_data():
    db = sqlite3.connect(db_path)
    arr = []
    for row in db.execute("SELECT key, sender, pub_time, pub_value, new_value FROM Publications"):
        arr.append({"key": row[0], "sender": row[1], "pub_time": row[2], "pub_value": row[3], "new": bool(row[4])})
    return jsonify(arr)


@app.route("/api/message-data", methods=["GET"])
def message_data():
    db = sqlite3.connect(db_path)

    arr = []
    for row in db.execute("SELECT sender, destination, send_time, receive_time, value, new_value FROM Messages"):
        arr.append({"sender": row[0], "destination": row[1], "send_time": row[2], "receive_time": row[3], "value": row[4], "new_value": row[5]})
    return jsonify(arr)


@app.route("/api/fast-forward-federation", methods=["PUT"])
def fast_forward_federation():
    global server_message_handler
    if server_message_handler.Enabled:
        server_message_handler.send_helics(SimpleMessage("SIGNAL", '{"operation": "FASTFORWARD"}'))
        result = server_message_handler.get_helics()
        return str(result)
    else:
        return jsonify({"success": False}), 400


@app.route("/api/stop-federation", methods=["PUT"])
def stop_federation():
    global server_message_handler
    if server_message_handler.Enabled:
        server_message_handler.send_helics(SimpleMessage("SIGNAL", '{"operation": "STOP"}'))
        result = server_message_handler.get_helics()
        return str(result)
    else:
        return jsonify({"success": False}), 400


@app.route("/api/signal-federation", methods=["GET"])
def signal_federation():
    global server_message_handler
    target_time = request.args.get("target_time", "")
    if server_message_handler.Enabled:
        logger.debug("sending signal to helics")
        server_message_handler.send_helics(SimpleMessage("SIGNAL", f'{{"operation": "RUNTO", "target_time": {target_time}}}'))
        logger.debug("retrieving response from helics")
        result = server_message_handler.get_helics()
        return str(result)
    else:
        return jsonify({"success": False}), 400


@app.route("/api/query-federation", methods=["GET"])
def query_federation():
    global server_message_handler
    target = request.args.get("target", "")
    topic = request.args.get("topic", "")
    name = request.args.get("name", "")
    fedSpec = request.args.get("fedSpec", "")

    result = ""

    if server_message_handler.Enabled:
        if target == "CORE":
            if topic == "GLOBAL_TIME":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"root", "query": "global_time"}'))
            elif topic == "FEDERATION_STATE":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"root", "query": "current_state"}'))
            result = server_message_handler.get_helics()
        elif target == "FEDERATE":
            if fedSpec == "VALUE":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"' + name + '", "query": "values"}'))
            elif fedSpec == "GRANTED_TIME":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"' + name + '", "query": "current_time"}'))
            elif fedSpec == "PUBS":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"' + name + '", "query": "publications"}'))
            elif fedSpec == "SUBS":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"' + name + '", "query": "subscriptions"}'))
            elif fedSpec == "INPUTS":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"' + name + '", "query": "inputs"}'))
            elif fedSpec == "ENDPOINTS":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"' + name + '", "query": "endpoints"}'))
            elif fedSpec == "FILTERS":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"' + name + '", "query": "filters"}'))
            elif fedSpec == "STATE":
                server_message_handler.send_helics(SimpleMessage("QUERY", '{"target":"' + name + '", "query": "state"}'))
            result = server_message_handler.get_helics()
        else:
            return jsonify({"success": False}), 400
        return str(result)
    else:
        return jsonify({"success": False}), 400


def startup(browser: bool, config_path: str = str(DATABASE_DIRECTORY), message_handler: MessageHandler = None):
    global server_message_handler
    global db_path

    if message_handler is not None and message_handler.Enabled:
        server_message_handler = message_handler

    path_to_config = os.path.abspath(config_path)
    db_path = os.path.dirname(path_to_config) + "/helics-cli.db"

    print(f"using db path {db_path}")
    db_init(db_path, logger)

    app.run(port=8000, debug=False, use_reloader=False)
    if browser:
        webbrowser.open_new("127.0.0.1:8000")


if __name__ == "__main__":
    logger.setLevel(logging.DEBUG)
    file_out = logging.FileHandler("server.log", mode="w")
    file_out.setLevel(logging.DEBUG)
    stream_out = logging.StreamHandler()
    stream_out.setLevel(logging.ERROR)
    logger.addHandler(file_out)
    logger.addHandler(stream_out)

    startup(True)
