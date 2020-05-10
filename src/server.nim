import jester
import json
import db_sqlite
import os

var federates: seq[string] = @[]

router helicsrouter:
 get "/":
   resp readFile(joinPath(getCurrentDir(), "html/index.html"))

 get "/federate-map.json":
  var f = open(joinPath(getCurrentDir(), "federate-map.json"), fmRead)
  var data = parseJson(f.readAll())
  resp $(%data), "application/json"

 get "/dependency-graph.json":
  var f = open(joinPath(getCurrentDir(), "dependency-graph.json"), fmRead)
  var data = parseJson(f.readAll())
  resp $(%data), "application/json"

 get "/data-flow-graph.json":
  var f = open(joinPath(getCurrentDir(), "data-flow-graph.json"), fmRead)
  var data = parseJson(f.readAll())
  resp $(%data), "application/json"

proc runServer*(): int =
  let port = Port(42069)
  let settings = newSettings(port=port)
  var jester = initJester(helicsrouter, settings=settings)
  jester.serve()
  return 0

when isMainModule:
  discard runServer()
