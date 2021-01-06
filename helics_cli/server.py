# -*- coding: utf-8 -*-
import pathlib
import sqlite3
import os
import webbrowser
import flask
# from .database import initialize_database
# from helics_cli.database import initialize_database
from flask import jsonify

DATABASE_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__))).parent / "database"
WEB_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__))).parent / "web"

app = flask.Flask(__name__,
                  static_url_path='',
                  static_folder=str(WEB_DIRECTORY / 'dist'))
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
    db = sqlite3.connect(str(DATABASE_DIRECTORY / "helics-cli.db"))
    arr = []
    for row in db.execute("SELECT name, granted, requested FROM Federates"):
        arr.append({"name": row[0], "granted": row[1], "requested": row[2]})
    return jsonify(arr)

@app.route("/api/named-federate-target-name", methods=["GET"])
def named_federate_target_name():
    arr = ["Named Federate Target 1", "Named Federate Target 2", "Named Federate Target 3", "Named Federate Target 4"]
    return jsonify(arr)
#     return jsonify(success=True)

@app.route("/api/publication-data", methods=["GET"])
def publication_data():
    db = sqlite3.connect(str(DATABASE_DIRECTORY / "helics-cli.db"))
    arr = []
    for row in db.execute("SELECT key, sender, pub_time, pub_value, new_value FROM Publications"):
        arr.append({"key": row[0], "sender": row[1], "pub_time": row[2], "pub_value": row[3], "new": bool(row[4])})
    return jsonify(arr)

# TODO Message Table in home
@app.route("/api/message-data", methods=["GET"])
def message_data():
    db = sqlite3.connect(str(DATABASE_DIRECTORY / "helics-cli.db"))

    ## Start Mock
    arr = []
    for i in range(5):
        arr.append({"fieldOne": "TODO " + str(i),"fieldTwo": "TODO " + str(i),"fieldThree": "TODO " + str(i),"fieldFour": "TODO " + str(i),"fieldFive": "TODO " + str(i)})
    ## End Mock

#     arr = []
#     for row in db.execute("SELECT key, sender, pub_time, pub_value, new_value FROM Publications"):
#         arr.append({"key": row[0], "sender": row[1], "pub_time": row[2], "pub_value": row[3], "new": bool(row[4])})
    return jsonify(arr)


@app.route("/api/fast-forward-federation", methods=["PUT"])
def fast_forward_federation():
    return jsonify(success=True)


@app.route("/api/stop-federation", methods=["PUT"])
def stop_federation():
    return jsonify(success=True)


@app.route("/api/signal-federation", methods=["PUT"])
def signal_federation():
    return jsonify(success=True)


def startup(web: bool):
    # initialize_database(str(DATABASE_DIRECTORY / "helics-cli.db"))
    app.run(port=8000)
    if web:
        webbrowser.open_new("127.0.0.1:8000")


if __name__ == "__main__":
    startup(True)
