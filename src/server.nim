import jester
import json
# import db_sqlite
import os

# var federates: seq[string] = @[]

router helicsrouter:
 get "/":
  if fileExists(joinPath(getCurrentDir(), "/web/dist/index.html")):
    resp readFile(joinPath(getCurrentDir(), "/web/dist/index.html"))
  else:
    resp readFile(joinPath(getCurrentDir(), "/web/notfound.html"))

 get "/api/federate-time":
  var f = open(joinPath(getCurrentDir(), "/web/src/json/federate-time.json"), fmRead)
  var data = parseJson(f.readAll())
  resp $(%data), "application/json"

 get "/api/publication-data":
  var f = open(joinPath(getCurrentDir(), "/web/src/json/publication-data.json"), fmRead)
  var data = parseJson(f.readAll())
  resp $(%data), "application/json"

#  get "/api/dependency-graph":
#   var f = open(joinPath(getCurrentDir(), "/web/src/json/dependency-graph.json"), fmRead)
#   var data = parseJson(f.readAll())
#   resp $(%data), "application/json"

#  get "/api/data-flow-graph":
#   var f = open(joinPath(getCurrentDir(), "/web/src/json/data-flow-graph.json"), fmRead)
#   var data = parseJson(f.readAll())
#   resp $(%data), "application/json"

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
  jester.serve()
  return 0

when isMainModule:
  discard runServer()
