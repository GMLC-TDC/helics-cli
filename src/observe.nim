import strformat
import strutils
import json
import os
import strformat
import strutils
import sequtils
import sugar
import db_sqlite
import ./database
import ./utils

import helics

proc initCombinationFederate(
    l: HelicsLibrary,
    core_name: string,
    nfederates = 1,
    core_type = "zmq",
    core_init_string = "",
    broker_init_string = "",
    delta = 0.5,
    log_level = 7,
    strict_type_checking = true,
    terminate_on_error = true,
  ): HelicsFederate =

  var err = l.helicsErrorInitialize()
  let core_init = &"{core_init_string} --federates={nfederates}"

  let fedinfo = l.helicsCreateFederateInfo()
  l.helicsFederateInfoSetCoreName(fedinfo, &"{core_name}Core")
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

proc writeDbData(l: HelicsLibrary, db: DbConn, fed: HelicsFederate, sublist: seq[tuple[name: string, input: HelicsInput]]) = 
  var q: HelicsQuery

  q = l.helicsCreateQuery("root", "federates")
  var federates = l.helicsQueryExecute(q, fed).toString().replace("[", "").replace("]", "").split(";")
  l.helicsQueryFree(q)

  var response = ""
  for name in federates:
    echo "name \"", name, "\""

    q = l.helicsCreateQuery(name, "exists")
    response = l.helicsQueryExecute(q, fed)
    echo "    exists: \"", response, "\""
    l.helicsQueryFree(q)

    q = l.helicsCreateQuery(name, "current_time")
    response = l.helicsQueryExecute(q, fed)
    let currentTimeJson = parseJson(response)
    let grantedTime = currentTimeJson{"granted_time"}.getFloat()
    let requestedTime = currentTimeJson{"requested_time"}.getFloat()
    echo &"    time: \"{response} => grant: {grantedTime}, request: {requestedTime} \""
    l.helicsQueryFree(q)

    db.exec(sql"INSERT INTO Federates(name, granted, requested) VALUES (?,?,?);", name, grantedTime, requestedTime)

    q = l.helicsCreateQuery(name, "publications")
    var publications = l.helicsQueryExecute(q, fed).toString().replace("[", "").replace("]", "").split(";")
    l.helicsQueryFree(q)

    for pub in publications:
      let sub = sublist.filter(x => x.name == pub)
      if(sub.len > 1):
        echo "ERROR: multiple subscriptions to same publication."
      elif not isEmptyOrWhitespace(pub) and sub.len == 1:
        # TODO: find requested time and insert
        let value = l.helicsInputGetDouble(sub[0].input)

        db.exec(sql"UPDATE Publications SET new_value=0;")
        db.exec(sql"INSERT INTO Publications(key, sender, pub_time, pub_value, new_value) VALUES (?,?,?,?,?);", 
        pub, name, grantedTime, value, 1)

proc runObserverFederate*(nfederates: int): int =
  print("Loading HELICS Library", sInfo)
  let l = loadHelicsLibrary("libhelicsSharedLib(|d)(|.2.5.2|.2.5.1|.2.5.0).(dylib|so|dll)")

  print("Initializing database", sInfo)
  var db = initializeDatabase("database/helics_cli.db")

  db.insertMetaData("version", $(l.helicsGetVersion()))
  echo "Creating broker"

  let broker = l.helicsCreateBroker("zmq", "CoreBroker", &"-f {nfederates + 1}")

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

  # Subscribe to all topics
  q = l.helicsCreateQuery("root", "publications")

  let pubBuffer = l.helicsQueryExecute(q, fed).toString()
  echo &"Pubs: {pubBuffer}"
  var publications = pubBuffer.replace("[", "").replace("]", "").split(";")
  l.helicsQueryFree(q)

  var sublist = newSeq[tuple[name: string, input: HelicsInput]]()
  for pub in publications:
    sublist.insert((name: pub, input: l.helicsFederateRegisterSubscription(fed, pub, "")))
 
  echo "Starting observer federate"


  l.helicsFederateEnterExecutingMode(fed)

  q = l.helicsCreateQuery("root", "brokers")
  var response = l.helicsQueryExecute(q, fed)
  echo "    output: \"", response, "\""
  l.helicsQueryFree(q)

  # q = l.helicsCreateQuery("root", "data_flow_graph")
  # response = l.helicsQueryExecute(q, fed)
  # echo "    data_flow_graph: \"", response, "\""
  # l.helicsQueryFree(q)

  var currenttime = 0.0
  var first = true
  block observe:
    while true:
      echo &"Current time is {currenttime}"
      currenttime = l.helicsFederateRequestTime(fed, 9223372036.0)
      echo &"Granted time {currenttime}, calling DB Write"
      if first == true:
        first = false
        q = l.helicsCreateQuery("root", "data_flow_graph")
        var response = l.helicsQueryExecute(q, fed)
        echo "    data_flow_graph: \"", response, "\""
        l.helicsQueryFree(q)

      writeDbData(l, db, fed, sublist)
      echo &"End of DB Write"
      if currenttime >= 9223372036.0: # TODO: replace hard coded helics_time_maxtime with proper value.
        break observe


  db.close()

  return 0