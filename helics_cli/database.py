# -*- coding: utf-8 -*-
import sqlite3
import os
import glob
import pathlib

DATABASE_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__))).parent / "database"


def initialize_database(filename: str):

    path = DATABASE_DIRECTORY / filename
    print(path)
    db = sqlite3.connect(str(path))
    for filename in glob.glob(str(DATABASE_DIRECTORY / "Schema/*.sql")):
        filename = DATABASE_DIRECTORY / filename
        with open(filename) as f:
            sql_file = f.read()
        print(f"read file {filename} to SQL")
        print(f"SQL: {sql_file}")
        try:
            db.execute(sql_file)
        except sqlite3.OperationalError as e:
            print(e)

    return db


class MetaData:
    def __init__(self, db):
        self.db = db

    def __getitem__(self, index):
        raise NotImplementedError("Not implemented yet.")

    def __setitem__(self, index, value):
        self.db.execute("INSERT INTO MetaData(name, value) VALUES (?, ?);", (index, value))
        self.db.commit()
