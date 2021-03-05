# -*- coding: utf-8 -*-
import sqlite3
import os
import glob
import pathlib
import logging

DATABASE_DIRECTORY = pathlib.Path(os.path.dirname(os.path.realpath(__file__))).parent / "database"


def initialize_database(filename: str, logger: logging.Logger = logging.getLogger(__name__)):

    logger.info(filename)
    logger.info(DATABASE_DIRECTORY)
    db = sqlite3.connect(str(filename))
    for filename in glob.glob(str(DATABASE_DIRECTORY / "Schema/*.sql")):
        filename = filename
        with open(filename) as f:
            sql_file = f.read()
        logger.info(f"read file {filename} to SQL")
        logger.info(f"SQL: {sql_file}")
        try:
            db.execute(sql_file)
        except sqlite3.OperationalError as e:
            logger.error(e)

    return db


class MetaData:
    def __init__(self, db):
        self.db = db

    def __getitem__(self, index):
        raise NotImplementedError("Not implemented yet.")

    def __setitem__(self, index, value):
        self.db.execute("INSERT INTO MetaData(name, value) VALUES (?, ?);", (index, value))
        self.db.commit()
