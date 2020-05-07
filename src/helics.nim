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
  helicsFederateInfoSetCoreName(fedinfo, "server", err.addr)
  helicsFederateInfoSetCoreTypeFromString(fedinfo, core_type, err.addr)
  helicsFederateInfoSetCoreInitString(fedinfo, core_init, err.addr)
  helicsFederateInfoSetTimeProperty(fedinfo, helics_property_time_delta.cint, delta, err.addr)
  helicsFederateInfoSetFlagOption(fedinfo, helics_flag_terminate_on_error.cint, true.cint, err.addr)
  helicsFederateInfoSetFlagOption(fedinfo, helics_handle_option_strict_type_checking.cint, true.cint, err.addr)

  let f = helicsCreateCombinationFederate(core_name, fedinfo, err.addr)

  return f


proc runServer*() =
  echo "Creating server federate"

  let f = initCombinationFederate("server")

  echo "Entering initializing mode"

  var err = helicsErrorInitialize()

  helicsFederateEnterInitializingMode(f, err.addr)

  echo "Querying all topics"

  var q: helics_query

  q = helicsCreateQuery("root", "federates")
  let federate_cstring = helicsQueryExecute(q, f, err.addr)
  var federate_string = newString(federate_cstring.len)
  copyMem(addr(federate_string[0]), federate_cstring, federate_cstring.len)

  var federates = federate_string.replace("[", "").replace("]", "").split(";")
  echo federates

  for name in federates:
    echo "name \"", name, "\""

    q = helicsCreateQuery(name, "exists")
    echo "    exists: \"", helicsQueryExecute(q, f, err.addr), "\""

    q = helicsCreateQuery(name, "subscriptions")
    echo "    subscriptions: \"", helicsQueryExecute(q, f, err.addr), "\""

    q = helicsCreateQuery(name, "endpoints")
    echo "    endpoints: \"", helicsQueryExecute(q, f, err.addr), "\""

    q = helicsCreateQuery(name, "inputs")
    echo "    inputs: \"", helicsQueryExecute(q, f, err.addr), "\""

    q = helicsCreateQuery(name, "publications")
    echo "    publications: \"", helicsQueryExecute(q, f, err.addr), "\""

  q = helicsCreateQuery("root", "federate_map")
  let federate_map = helicsQueryExecute(q, f, err.addr)

  q = helicsCreateQuery("root", "dependency_graph")
  let dependency_graph = helicsQueryExecute(q, f, err.addr)

  echo dependency_graph
  echo federate_map

  echo "Starting server"

  helicsFederateEnterExecutingMode(f, err.addr)

  var currenttime = 0.0
  while currenttime <= 100:
    echo &"Current time is {currenttime}"
    currenttime = helicsFederateRequestTime(f, 100, err.addr)

  helicsFederateFinalize(f, err.addr)
  helicsFederateFree(f)
  helicsCloseLibrary()
