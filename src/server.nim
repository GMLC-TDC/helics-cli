import jester
import json
import db_sqlite
import os
import strutils
import browsers

let db = open(joinPath(getCurrentDir(), "/database/helics_cli.db"), "","","")

router helicsrouter:
 get "/":
  if fileExists(joinPath(getCurrentDir(), "/web/dist/index.html")):
    resp readFile(joinPath(getCurrentDir(), "/web/dist/index.html"))
  else:
    resp readFile(joinPath(getCurrentDir(), "/web/notfound.html"))

 get "/api/federate-time":
  var localJsonArray = %* []
  for row in db.fastRows(sql"SELECT name, granted, requested FROM Federates"):
    localJsonArray.add(%* {"name": row[0], "granted": row[1], "requested": row[2]})
  var response = ""
  toUgly(response, localJsonArray)
  resp response, "application/json"

 get "/api/publication-data":
  var localJsonArray = %* []
  for row in db.fastRows(sql"SELECT key, sender, pub_time, pub_value, new_value FROM Publications"):
    localJsonArray.add(%* {"key": row[0], "sender": row[1], "pub_time": row[2], "pub_value": row[3], "new": parseBool(row[4])})
  var response = ""
  toUgly(response, localJsonArray)
  resp response, "application/json"

 put "/api/FastForwardFederation":
  resp Http200, ""

 put "/api/StopFederation":
  resp Http200, ""

 put "/api/signalFederation":
  resp Http200, ""

proc runServer*(): int =
  let port = Port(8000)
  let settings = newSettings(port=port,staticDir="./web/dist")
  var jester = initJester(helicsrouter, settings=settings)
  openDefaultBrowser("http://127.0.0.1:8000")
  jester.serve()
  return 0

when isMainModule:
  discard runServer()
