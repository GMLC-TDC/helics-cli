# -*- coding: utf-8 -*-
import pathlib
import sqlite3
import os
import flask
from flask import jsonify

DATABASE_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__))).parent / "database"
WEB_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__))).parent / "web"

app = flask.Flask(__name__)
app.config["DEBUG"] = True
app.config["PORT"] = 8000

db = sqlite3.connect(str(DATABASE_DIRECTORY / "helics-cli.db"))


@app.route("/", methods=["GET"])
def index():
    if (WEB_DIRECTORY / "dist/index.html").exists():
        with open(str(WEB_DIRECTORY / "dist/index.html")) as f:
            return f.read()
    else:
        with open(str(WEB_DIRECTORY / "dist/notfound.html")) as f:
            return f.read()


@app.route("/api/federate-time", methods=["GET"])
def federate_time():
    arr = []
    for row in db.execute("SELECT name, granted, requested FROM Federates"):
        arr.append({"name": row[0], "granted": row[1], "requested": row[2]})
    return jsonify(arr)


@app.route("/api/publication-data", methods=["GET"])
def publication_data():
    arr = []
    for row in db.execute("SELECT key, sender, pub_time, pub_value, new_value FROM Publications"):
        arr.append({"key": row[0], "sender": row[1], "pub_time": row[2], "pub_value": row[3], "new": bool(row[4])})
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


app.run()
