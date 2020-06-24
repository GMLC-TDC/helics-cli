import strformat
import strutils
import json
import os
import strformat
import strutils
import sequtils
import db_sqlite
import ./database

import helics

proc initCombinationFederate(
    l: HelicsLibrary,
    core_name: string,
    nfederates = 1,
    core_type = "zmq",
    core_init_string = "",
    broker_init_string = "",
    delta = 0.0,
    log_level = 7,
    strict_type_checking = true,
    terminate_on_error = true,
  ): HelicsFederate =

  var err = l.helicsErrorInitialize()
  let core_init = &"{core_init_string} --federates={nfederates}"

  let fedinfo = l.helicsCreateFederateInfo()
  l.helicsFederateInfoSetCoreName(fedinfo, core_name)
  l.helicsFederateInfoSetCoreTypeFromString(fedinfo, core_type)
  l.helicsFederateInfoSetCoreInitString(fedinfo, core_init)
  l.helicsFederateInfoSetTimeProperty(fedinfo, HELICS_PROPERTY_TIME_DELTA.int, delta)
  l.helicsFederateInfoSetFlagOption(fedinfo, HELICS_FLAG_TERMINATE_ON_ERROR.int, true)
  l.helicsFederateInfoSetFlagOption(fedinfo, HELICS_HANDLE_OPTION_STRICT_TYPE_CHECKING.cint, true)

  let fed = l.helicsCreateCombinationFederate(core_name, fedinfo)
  return fed

proc toString(cs: cstring): string =
  var s = newString(cs.len)
  copyMem(addr(s[0]), cs, cs.len)
  return s

proc runObserverFederate*(nfederates: int): int =
  let l = loadHelicsLibrary("libhelicsSharedLib(|.2.5.2|.2.5.1|.2.5.0).dylib")

  var db = initializeDatabase("helics.db")

  db.insertMetaData("version", $(l.helicsGetVersion()))
  echo "Creating broker"

  let broker = l.helicsCreateBroker("zmq", "", &"-f {nfederates + 1}")

  db.insertMetaData("nfederates", nfederates)

  defer:
    while l.helicsBrokerIsConnected(broker) == true:
      os.sleep(250)

    l.helicsCloseLibrary()

  echo "Creating observer federate"

  let fed = initCombinationFederate(l, "__observer__")

  defer:
    l.helicsFederateFinalize(fed)
    l.helicsFederateFree(fed)

  echo "Entering initializing mode"
  l.helicsFederateEnterInitializingMode(fed)

  echo "Querying all topics"

  var q: HelicsQuery

  q = l.helicsCreateQuery("root", "federates")
  var federates = l.helicsQueryExecute(q, fed).toString().replace("[", "").replace("]", "").split(";")
  l.helicsQueryFree(q)

  db.insertMetaData("federates", federates.filterIt(not it.startswith("__")).join(","))

  for name in federates:
    echo "name \"", name, "\""

    q = l.helicsCreateQuery(name, "exists")
    echo "    exists: \"", l.helicsQueryExecute(q, fed), "\""
    l.helicsQueryFree(q)

    q = l.helicsCreateQuery(name, "subscriptions")
    echo "    subscriptions: \"", l.helicsQueryExecute(q, fed), "\""
    l.helicsQueryFree(q)

    q = l.helicsCreateQuery(name, "endpoints")
    echo "    endpoints: \"", l.helicsQueryExecute(q, fed), "\""
    l.helicsQueryFree(q)

    q = l.helicsCreateQuery(name, "inputs")
    echo "    inputs: \"", l.helicsQueryExecute(q, fed), "\""
    l.helicsQueryFree(q)

    q = l.helicsCreateQuery(name, "publications")
    echo "    publications: \"", l.helicsQueryExecute(q, fed), "\""
    l.helicsQueryFree(q)

  q = l.helicsCreateQuery("root", "federate_map")
  let federate_map = l.helicsQueryExecute(q, fed).toString()
  l.helicsQueryFree(q)

  q = l.helicsCreateQuery("root", "dependency_graph")
  let dependency_graph = l.helicsQueryExecute(q, fed).toString()
  l.helicsQueryFree(q)

  q = l.helicsCreateQuery("root", "data_flow_graph")
  let data_flow_graph = l.helicsQueryExecute(q, fed).toString()
  l.helicsQueryFree(q)

  var jsonfile: File
  jsonfile = open(joinPath(getCurrentDir(), "dependency-graph.json"), fmWrite)
  jsonfile.write(parseJson(dependency_graph).pretty(indent = 2))
  jsonfile.close()

  jsonfile = open(joinPath(getCurrentDir(), "federate-map.json"), fmWrite)
  jsonfile.write(parseJson(federate_map).pretty(indent = 2))
  jsonfile.close()

  jsonfile = open(joinPath(getCurrentDir(), "data-flow-graph.json"), fmWrite)
  jsonfile.write(parseJson(data_flow_graph).pretty(indent = 2))
  jsonfile.close()

  echo "Starting observer federate"

  # TODO: subscribe to all topics

  l.helicsFederateEnterExecutingMode(fed)

  var currenttime = 0.0
  while currenttime < 100.0:
    echo &"Current time is {currenttime}"
    currenttime = l.helicsFederateRequestTime(fed, 100.0)

  db.close()

  return 0
