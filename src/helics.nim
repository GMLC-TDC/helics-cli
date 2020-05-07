include private/helics_enums
include private/api_data
include private/helics

import strformat

proc initCombinationFederate*(
    core_name: string,
    nfederates = 3,
    core_type = "zmq",
    core_init_string = "",
    broker_init_string = "",
    delta = 0.0,
    log_level = 7,
    strict_type_checking = true,
    terminate_on_error = true,
  ): helics_federate =

  var he = helicsErrorInitialize()
  let core_init = &"{core_init_string} --federates={nfederates}"

  let fedinfo = helicsCreateFederateInfo()
  helicsFederateInfoSetCoreName(fedinfo, "helics-injector", he.addr)
  helicsFederateInfoSetCoreTypeFromString(fedinfo, core_type, he.addr)
  helicsFederateInfoSetCoreInitString(fedinfo, core_init, he.addr)
  helicsFederateInfoSetTimeProperty(fedinfo, helics_property_time_delta.cint, delta, he.addr)
  helicsFederateInfoSetFlagOption(fedinfo, helics_flag_terminate_on_error.cint, true.cint, he.addr)
  helicsFederateInfoSetFlagOption(fedinfo, helics_handle_option_strict_type_checking.cint, true.cint, he.addr)

  let f = helicsCreateCombinationFederate(core_name, fedinfo, he.addr)

  return f
