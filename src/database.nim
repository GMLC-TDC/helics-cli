import os
import strformat
import db_sqlite

import ./utils

proc runSqlFile(db: DbConn, filename: string) = 
  let sqlFile = readFile(filename).sql
  print( &"read file {filename} to SQL", sInfo, silent=true)
  print( &"SQL: {sqlFile.string}", sInfo, silent=true)
  if not db.tryExec(sqlFile):
    print(&"Table for file {filename} already exists in database.", sWarn)

proc initializeTables(db: DbConn) = 
  for filename in walkFiles("database/Schema/*.sql"):
    runSqlFile(db, getCurrentDir() / filename)

proc initializeDatabase*(filename: string): DbConn =

  let path = getCurrentDir() / filename

  var db = open(connection=path, user="", password="", database="helicsFederation")

  db.exec(sql"DROP TABLE IF EXISTS meta_data")
  db.exec(sql"""
  CREATE TABLE meta_data (
    name  text,
    value text
  )""")

  initializeTables(db)

  return db

proc insertMetaData*(db: DbConn, key: string, value: int) =
  db.exec(sql"INSERT INTO meta_data(name, value) VALUES (?, ?);", key, value)

proc insertMetaData*(db: DbConn, key: string, value: string) =
  db.exec(sql"INSERT INTO meta_data(name, value) VALUES (?, ?);", key, value)
