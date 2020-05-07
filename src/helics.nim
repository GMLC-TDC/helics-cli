import private/helics_enums
import private/api_data
import private/helics

import strformat
import strutils
import httpclient
import json
import mimetypes
import os
import osproc
import sequtils
import shlex
import strformat
import strutils
import sugar
import terminal
import threadpool
import streams
import strtabs

proc initCombinationFederate*(
    core_name: string,
    nfederates = 1,
    core_type = "zmq",
    core_init_string = "",
    broker_init_string = "",
    delta = 0.0,
    log_level = 7,
    strict_type_checking = true,
    terminate_on_error = true,
  ): helics_federate =

  var err = helicsErrorInitialize()
  let core_init = &"{core_init_string} --federates={nfederates}"

  let fedinfo = helicsCreateFederateInfo()
  helicsFederateInfoSetCoreName(fedinfo, "hook", err.addr)
  helicsFederateInfoSetCoreTypeFromString(fedinfo, core_type, err.addr)
  helicsFederateInfoSetCoreInitString(fedinfo, core_init, err.addr)
  helicsFederateInfoSetTimeProperty(fedinfo, helics_property_time_delta.cint, delta, err.addr)
  helicsFederateInfoSetFlagOption(fedinfo, helics_flag_terminate_on_error.cint, true.cint, err.addr)
  helicsFederateInfoSetFlagOption(fedinfo, helics_handle_option_strict_type_checking.cint, true.cint, err.addr)

  let fed = helicsCreateCombinationFederate(core_name, fedinfo, err.addr)
  return fed

proc toString(cs: cstring): string =
  var s = newString(cs.len)
  copyMem(addr(s[0]), cs, cs.len)
  return s

proc runHookFederate*() =
  echo "Creating hook federate"

  let fed = initCombinationFederate("hook")

  echo "Entering initializing mode"

  var err = helicsErrorInitialize()

  helicsFederateEnterInitializingMode(fed, err.addr)

  echo "Querying all topics"

  var q: helics_query

  q = helicsCreateQuery("root", "federates")
  var federates = helicsQueryExecute(q, fed, err.addr).toString().replace("[", "").replace("]", "").split(";")
  echo federates

  for name in federates:
    echo "name \"", name, "\""

    q = helicsCreateQuery(name, "exists")
    echo "    exists: \"", helicsQueryExecute(q, fed, err.addr), "\""

    q = helicsCreateQuery(name, "subscriptions")
    echo "    subscriptions: \"", helicsQueryExecute(q, fed, err.addr), "\""

    q = helicsCreateQuery(name, "endpoints")
    echo "    endpoints: \"", helicsQueryExecute(q, fed, err.addr), "\""

    q = helicsCreateQuery(name, "inputs")
    echo "    inputs: \"", helicsQueryExecute(q, fed, err.addr), "\""

    q = helicsCreateQuery(name, "publications")
    echo "    publications: \"", helicsQueryExecute(q, fed, err.addr), "\""

  q = helicsCreateQuery("root", "federate_map")
  let federate_map = helicsQueryExecute(q, fed, err.addr).toString()

  q = helicsCreateQuery("root", "dependency_graph")
  let dependency_graph = helicsQueryExecute(q, fed, err.addr).toString()

  var jsonfile: File
  jsonfile = open(joinPath(getCurrentDir(), "dependency-graph.json"), fmWrite)
  jsonfile.write(parseJson(dependency_graph))
  jsonfile.close()

  jsonfile = open(joinPath(getCurrentDir(), "federate-map.json"), fmWrite)
  jsonfile.write(parseJson(federate_map))
  jsonfile.close()

  echo "Starting hook federate"

  helicsFederateEnterExecutingMode(fed, err.addr)

  var currenttime = 0.0
  while currenttime <= 100:
    echo &"Current time is {currenttime}"
    currenttime = helicsFederateRequestTime(fed, 100, err.addr)

  helicsFederateFinalize(fed, err.addr)
  helicsFederateFree(fed)
  helicsCloseLibrary()