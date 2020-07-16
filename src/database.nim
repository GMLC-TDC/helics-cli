import os
import strutils
import db_sqlite

proc initializeDatabase*(filename: string): DbConn =

  let path = getCurrentDir() / filename

  var db = open(connection=path, user="", password="", database="helicsFederation")

  db.exec(sql"DROP TABLE IF EXISTS meta_data")
  db.exec(sql"""
  CREATE TABLE meta_data (
    name  text,
    value text
  )""")

  return db


proc insertMetaData*(db: DbConn, key: string, value: int) =
  db.exec(sql"INSERT INTO meta_data(name, value) VALUES (?, ?);", key, value)

proc insertMetaData*(db: DbConn, key: string, value: string) =
  db.exec(sql"INSERT INTO meta_data(name, value) VALUES (?, ?);", key, value)
