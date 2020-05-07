##
## Copyright (c) 2017-2020,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##

when defined(windows):
  const helicsSharedLib* = "helicsSharedLib.dll"
elif defined(macosx):
  const helicsSharedLib* = "libhelicsSharedLib.dylib"
else:
  const helicsSharedLib* = "libhelicsSharedLib.so"

block:
  {.link: "./c2nim/lib/libhelicsSharedLib.dylib".}
  {.passc: "-I ./c2nim/include/helics/shared_api_library -Wall -Werror".}
  {.passl: """-Wl,-rpath,./c2nim/lib""".}

## * @file
##     @brief common functions for the HELICS C api
##
## **************************************************
##     Common Functions
## **************************************************
## * get a version string for HELICS

proc helicsGetVersion*(): cstring {.cdecl, importc: "helicsGetVersion",
                                 header: "helics.h".}
## * return an initialized error object

proc helicsErrorInitialize*(): helics_error {.cdecl,
    importc: "helicsErrorInitialize", header: "helics.h".}
## * clear an error object

proc helicsErrorClear*(err: ptr helics_error) {.cdecl, importc: "helicsErrorClear",
    header: "helics.h".}
## *
##  Returns true if core/broker type specified is available in current compilation.
##      @param type a string representing a core type
##      @details possible options include "test","zmq","udp","ipc","interprocess","tcp","default", "mpi"
##

proc helicsIsCoreTypeAvailable*(`type`: cstring): helics_bool {.cdecl,
    importc: "helicsIsCoreTypeAvailable", header: "helics.h".}
## * create a core object
##     @param type the type of the core to create
##     @param name the name of the core , may be a nullptr or empty string to have a name automatically assigned
##     @param initString an initialization string to send to the core-the format is similar to command line arguments
##     typical options include a broker address  --broker="XSSAF" or the number of federates or the address
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a helics_core object if the core is invalid err will contain some indication
##

proc helicsCreateCore*(`type`: cstring; name: cstring; initString: cstring;
                      err: ptr helics_error): helics_core {.cdecl,
    importc: "helicsCreateCore", header: "helics.h".}
## * create a core object by passing command line arguments
##     @param type the type of the core to create
##     @param name the name of the core , may be a nullptr or empty string to have a name automatically assigned
##     @param argc the number of arguments
##     @param argv the string values from a command line
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a helics_core object
##

proc helicsCreateCoreFromArgs*(`type`: cstring; name: cstring; argc: cint;
                              argv: cstringArray; err: ptr helics_error): helics_core {.
    cdecl, importc: "helicsCreateCoreFromArgs", header: "helics.h".}
## * create a new reference to an existing core
##     @details this will create a new broker object that references the existing broker it must be freed as well
##     @param core an existing helics_core
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a new reference to the same broker

proc helicsCoreClone*(core: helics_core; err: ptr helics_error): helics_core {.cdecl,
    importc: "helicsCoreClone", header: "helics.h".}
## * check if a core object is a valid object
##     @param core the helics_core object to test

proc helicsCoreIsValid*(core: helics_core): helics_bool {.cdecl,
    importc: "helicsCoreIsValid", header: "helics.h".}
## * create a broker object
##     @param type the type of the broker to create
##     @param name the name of the broker , may be a nullptr or empty string to have a name automatically assigned
##     @param initString an initialization string to send to the core-the format is similar to command line arguments
##     typical options include a broker address  --broker="XSSAF" if this is a subbroker or the number of federates or the address
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a helics_broker object, will be NULL if there was an error indicated in the err object
##

proc helicsCreateBroker*(`type`: cstring; name: cstring; initString: cstring;
                        err: ptr helics_error): helics_broker {.cdecl,
    importc: "helicsCreateBroker", header: "helics.h".}
## * create a core object by passing command line arguments
##     @param type the type of the core to create
##     @param name the name of the core , may be a nullptr or empty string to have a name automatically assigned
##     @param argc the number of arguments
##     @param argv the string values from a command line
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a helics_core object
##

proc helicsCreateBrokerFromArgs*(`type`: cstring; name: cstring; argc: cint;
                                argv: cstringArray; err: ptr helics_error): helics_broker {.
    cdecl, importc: "helicsCreateBrokerFromArgs", header: "helics.h".}
## * create a new reference to an existing broker
##     @details this will create a new broker object that references the existing broker it must be freed as well
##     @param broker an existing helics_broker
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a new reference to the same broker

proc helicsBrokerClone*(broker: helics_broker; err: ptr helics_error): helics_broker {.
    cdecl, importc: "helicsBrokerClone", header: "helics.h".}
## * check if a broker object is a valid object
##     @param broker the helics_broker object to test

proc helicsBrokerIsValid*(broker: helics_broker): helics_bool {.cdecl,
    importc: "helicsBrokerIsValid", header: "helics.h".}
## * check if a broker is connected
##   a connected broker implies is attached to cores or cores could reach out to communicate
##   return 0 if not connected , something else if it is connected

proc helicsBrokerIsConnected*(broker: helics_broker): helics_bool {.cdecl,
    importc: "helicsBrokerIsConnected", header: "helics.h".}
## * link a named publication and named input using a broker
##     @param broker the broker to generate the connection from
##     @param source the name of the publication (cannot be NULL)
##     @param target the name of the target to send the publication data (cannot be NULL)
##     @forcpponly
##     @param[in,out] err a helics_error object, can be NULL if the errors are to be ignored
##     @endforcpponly
##

proc helicsBrokerDataLink*(broker: helics_broker; source: cstring; target: cstring;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerDataLink", header: "helics.h".}
## * link a named filter to a source endpoint
##     @param broker the broker to generate the connection from
##     @param filter the name of the filter (cannot be NULL)
##     @param endpoint the name of the endpoint to filter the data from (cannot be NULL)
##     @forcpponly
##     @param[in,out] err a helics_error object, can be NULL if the errors are to be ignored
##     @endforcpponly
##

proc helicsBrokerAddSourceFilterToEndpoint*(broker: helics_broker; filter: cstring;
    endpoint: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerAddSourceFilterToEndpoint", header: "helics.h".}
## * link a named filter to a destination endpoint
##     @param broker the broker to generate the connection from
##     @param filter the name of the filter (cannot be NULL)
##     @param endpoint the name of the endpoint to filter the data going to (cannot be NULL)
##     @forcpponly
##     @param[in,out] err a helics_error object, can be NULL if the errors are to be ignored
##     @endforcpponly
##

proc helicsBrokerAddDestinationFilterToEndpoint*(broker: helics_broker;
    filter: cstring; endpoint: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerAddDestinationFilterToEndpoint", header: "helics.h".}
## * load a file containing connection information
##     @param broker the broker to generate the connections from
##     @param file a JSON or TOML file containing connection information
##     @forcpponly
##     @param[in,out] err a helics_error object, can be NULL if the errors are to be ignored
##     @endforcpponly
##

proc helicsBrokerMakeConnections*(broker: helics_broker; file: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerMakeConnections", header: "helics.h".}
## * wait for the core to disconnect
##   @param core the core to wait for
##   @param msToWait the time out in millisecond (<0 for infinite timeout)
##   @forcpponly
##   @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##   @endforcpponly
##   @return helics_true if the disconnect was successful,  helics_false if there was a timeout
##

proc helicsCoreWaitForDisconnect*(core: helics_core; msToWait: cint;
                                 err: ptr helics_error): helics_bool {.cdecl,
    importc: "helicsCoreWaitForDisconnect", header: "helics.h".}
## * wait for the broker to disconnect
##  @param broker the broker to wait for
##  @param msToWait the time out in millisecond (<0 for infinite timeout)
##  @forcpponly
##  @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##  @endforcpponly
##  @return helics_true if the disconnect was successful,  helics_false if there was a timeout
##

proc helicsBrokerWaitForDisconnect*(broker: helics_broker; msToWait: cint;
                                   err: ptr helics_error): helics_bool {.cdecl,
    importc: "helicsBrokerWaitForDisconnect", header: "helics.h".}
## * check if a core is connected
##     a connected core implies is attached to federate or federates could be attached to it
##     return helics_false if not connected, helics_true if it is connected

proc helicsCoreIsConnected*(core: helics_core): helics_bool {.cdecl,
    importc: "helicsCoreIsConnected", header: "helics.h".}
## * link a named publication and named input using a core
##     @param core the core to generate the connection from
##     @param source the name of the publication (cannot be NULL)
##     @param target the named of the target to send the publication data (cannot be NULL)
##     @forcpponly
##     @param[in,out] err a helics_error object, can be NULL if the errors are to be ignored
##     @endforcpponly
##

proc helicsCoreDataLink*(core: helics_core; source: cstring; target: cstring;
                        err: ptr helics_error) {.cdecl,
    importc: "helicsCoreDataLink", header: "helics.h".}
## * link a named filter to a source endpoint
##     @param core the core to generate the connection from
##     @param filter the name of the filter (cannot be NULL)
##     @param endpoint the name of the endpoint to filter the data from (cannot be NULL)
##     @forcpponly
##     @param[in,out] err a helics_error object, can be NULL if the errors are to be ignored
##     @endforcpponly
##

proc helicsCoreAddSourceFilterToEndpoint*(core: helics_core; filter: cstring;
    endpoint: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreAddSourceFilterToEndpoint", header: "helics.h".}
## * link a named filter to a destination endpoint
##     @param core the core to generate the connection from
##     @param filter the name of the filter (cannot be NULL)
##     @param endpoint the name of the endpoint to filter the data going to (cannot be NULL)
##     @forcpponly
##     @param[in,out] err a helics_error object, can be NULL if the errors are to be ignored
##     @endforcpponly
##

proc helicsCoreAddDestinationFilterToEndpoint*(core: helics_core; filter: cstring;
    endpoint: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreAddDestinationFilterToEndpoint", header: "helics.h".}
## * load a file containing connection information
##     @param core the core to generate the connections from
##     @param file a JSON or TOML file containing connection information
##     @forcpponly
##     @param[in,out] err a helics_error object, can be NULL if the errors are to be ignored
##     @endforcpponly
##

proc helicsCoreMakeConnections*(core: helics_core; file: cstring;
                               err: ptr helics_error) {.cdecl,
    importc: "helicsCoreMakeConnections", header: "helics.h".}
## * get an identifier for the broker
##     @param broker the broker to query
##     @return a string containing the identifier for the broker
##

proc helicsBrokerGetIdentifier*(broker: helics_broker): cstring {.cdecl,
    importc: "helicsBrokerGetIdentifier", header: "helics.h".}
## * get an identifier for the core
##     @param core the core to query
##     @return a string with the identifier of the core
##

proc helicsCoreGetIdentifier*(core: helics_core): cstring {.cdecl,
    importc: "helicsCoreGetIdentifier", header: "helics.h".}
## * get the network address associated with a broker
##     @param broker the broker to query
##     @return a string with the network address of the broker
##

proc helicsBrokerGetAddress*(broker: helics_broker): cstring {.cdecl,
    importc: "helicsBrokerGetAddress", header: "helics.h".}
## * get the network address associated with a core
##     @param core the core to query
##     @return a string with the network address of the broker
##

proc helicsCoreGetAddress*(core: helics_core): cstring {.cdecl,
    importc: "helicsCoreGetAddress", header: "helics.h".}
## * set the core to ready for init
##     @details this function is used for cores that have filters but no federates so there needs to be
##     a direct signal to the core to trigger the federation initialization
##     @param core the core object to enable init values for
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsCoreSetReadyToInit*(core: helics_core; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreSetReadyToInit", header: "helics.h".}
## * connect a core to the federate based on current configuration
##     @param core the core to connect
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsCoreConnect*(core: helics_core; err: ptr helics_error): helics_bool {.cdecl,
    importc: "helicsCoreConnect", header: "helics.h".}
## * disconnect a core from the federation
##     @param core the core to query
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsCoreDisconnect*(core: helics_core; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreDisconnect", header: "helics.h".}
## * get an existing federate object from a core by name
##     @details the federate must have been created by one of the other functions and at least one of the objects referencing the created
##     federate must still be active in the process
##     @param fedName the name of the federate to retrieve
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return NULL if no fed is available by that name otherwise a helics_federate with that name

proc helicsGetFederateByName*(fedName: cstring; err: ptr helics_error): helics_federate {.
    cdecl, importc: "helicsGetFederateByName", header: "helics.h".}
## * disconnect a broker
##     @param broker the broker to disconnect
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsBrokerDisconnect*(broker: helics_broker; err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerDisconnect", header: "helics.h".}
## * disconnect and free a broker

proc helicsFederateDestroy*(fed: helics_federate) {.cdecl,
    importc: "helicsFederateDestroy", header: "helics.h".}
## * disconnect and free a broker

proc helicsBrokerDestroy*(broker: helics_broker) {.cdecl,
    importc: "helicsBrokerDestroy", header: "helics.h".}
## * disconnect and free a core

proc helicsCoreDestroy*(core: helics_core) {.cdecl, importc: "helicsCoreDestroy",
    header: "helics.h".}
## * release the memory associated with a core

proc helicsCoreFree*(core: helics_core) {.cdecl, importc: "helicsCoreFree",
                                       header: "helics.h".}
## * release the memory associated with a broker

proc helicsBrokerFree*(broker: helics_broker) {.cdecl, importc: "helicsBrokerFree",
    header: "helics.h".}
##  Creation and destruction of Federates
## * create a value federate from a federate info object
##     @details helics_federate objects can be used in all functions that take a helics_federate or helics_federate object as an argument
##     @param fedName the name of the federate to create, can NULL or an empty string to use the default name from fi or an assigned name
##     @param fi the federate info object that contains details on the federate
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return an opaque value federate object
##

proc helicsCreateValueFederate*(fedName: cstring; fi: helics_federate_info;
                               err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateValueFederate", header: "helics.h".}
## * create a value federate from a JSON file, JSON string, or TOML file
##     @details helics_federate objects can be used in all functions that take a helics_federate or helics_federate object as an argument
##     @param configFile  a JSON file or a JSON string or TOML file that contains setup and configuration information
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return an opaque value federate object
##

proc helicsCreateValueFederateFromConfig*(configFile: cstring;
    err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateValueFederateFromConfig", header: "helics.h".}
## * create a message federate from a federate info object
##     @details helics_message_federate objects can be used in all functions that take a helics_message_federate or helics_federate object as
##     an argument
##     @param fedName the name of the federate to create
##     @param fi the federate info object that contains details on the federate
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return an opaque message federate object
##

proc helicsCreateMessageFederate*(fedName: cstring; fi: helics_federate_info;
                                 err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateMessageFederate", header: "helics.h".}
## * create a message federate from a JSON file or JSON string or TOML file
##     @details helics_message_federate objects can be used in all functions that take a helics_message_federate or helics_federate object as
##     an argument
##     @param configFile  a Config(JSON,TOML) file or a JSON string that contains setup and configuration information
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return an opaque message federate object
##

proc helicsCreateMessageFederateFromConfig*(configFile: cstring;
    err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateMessageFederateFromConfig", header: "helics.h".}
## * create a combination federate from a federate info object
##     @details combination federates are both value federates and message federates, objects can be used in all functions that take a
##     helics_federate, helics_message_federate or helics_federate object as an argument
##     @param fedName a string with the name of the federate, can be NULL or an empty string to pull the default name from fi
##     @param fi the federate info object that contains details on the federate
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return an opaque value federate object nullptr if the object creation failed
##

proc helicsCreateCombinationFederate*(fedName: cstring; fi: helics_federate_info;
                                     err: ptr helics_error): helics_federate {.
    cdecl, importc: "helicsCreateCombinationFederate", header: "helics.h".}
## * create a combination federate from a JSON file or JSON string
##     @details combination federates are both value federates and message federates, objects can be used in all functions that take a
##     helics_federate, helics_message_federate or helics_federate object as an argument
##     @param configFile  a JSON file or a JSON string or TOML file that contains setup and configuration information
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return an opaque combination federate object
##

proc helicsCreateCombinationFederateFromConfig*(configFile: cstring;
    err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateCombinationFederateFromConfig", header: "helics.h".}
## * create a new reference to an existing federate
##     @details this will create a new helics_federate object that references the existing federate it must be freed as well
##     @param fed an existing helics_federate
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a new reference to the same federate

proc helicsFederateClone*(fed: helics_federate; err: ptr helics_error): helics_federate {.
    cdecl, importc: "helicsFederateClone", header: "helics.h".}
## * create a federate info object for specifying federate information when constructing a federate
##     @return a helics_federate_info object which is a reference to the created object
##

proc helicsCreateFederateInfo*(): helics_federate_info {.cdecl,
    importc: "helicsCreateFederateInfo", header: "helics.h".}
## * create a federate info object from an existing one and clone the information
##     @param fi a federateInfo object to duplicate
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##      @return a helics_federate_info object which is a reference to the created object
##

proc helicsFederateInfoClone*(fi: helics_federate_info; err: ptr helics_error): helics_federate_info {.
    cdecl, importc: "helicsFederateInfoClone", header: "helics.h".}
## *load a federate info from command line arguments
##     @param fi a federateInfo object
##     @param argc the number of command line arguments
##     @param argv an array of strings from the command line
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoLoadFromArgs*(fi: helics_federate_info; argc: cint;
                                    argv: cstringArray; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateInfoLoadFromArgs", header: "helics.h".}
## * delete the memory associated with a federate info object

proc helicsFederateInfoFree*(fi: helics_federate_info) {.cdecl,
    importc: "helicsFederateInfoFree", header: "helics.h".}
## * check if a federate_object is valid
##     @return helics_true if the federate is a valid active federate, helics_false otherwise

proc helicsFederateIsValid*(fed: helics_federate): helics_bool {.cdecl,
    importc: "helicsFederateIsValid", header: "helics.h".}
## * set the name of the core to link to for a federate
##   @param fi the federate info object to alter
##   @param corename the identifier for a core to link to
##   @forcpponly
##   @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##   @endforcpponly
##

proc helicsFederateInfoSetCoreName*(fi: helics_federate_info; corename: cstring;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetCoreName", header: "helics.h".}
## * set the initialization string for the core usually in the form of command line arguments
##     @param fi the federate info object to alter
##     @param coreInit a string containing command line arguments to be passed to the core
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetCoreInitString*(fi: helics_federate_info;
    coreInit: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetCoreInitString", header: "helics.h".}
## * set the initialization string that a core will pass to a generated broker usually in the form of command line arguments
##     @param fi the federate info object to alter
##     @param brokerInit a string with command line arguments for a generated broker
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetBrokerInitString*(fi: helics_federate_info;
    brokerInit: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetBrokerInitString", header: "helics.h".}
## * set the core type by integer code
##     @details valid values available by definitions in api-data.h
##     @param fi the federate info object to alter
##     @param coretype an numerical code for a core type see /ref helics_core_type
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetCoreType*(fi: helics_federate_info; coretype: cint;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetCoreType", header: "helics.h".}
## * set the core type from a string
##     @param fi the federate info object to alter
##     @param coretype a string naming a core type
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetCoreTypeFromString*(fi: helics_federate_info;
    coretype: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetCoreTypeFromString", header: "helics.h".}
## * set the name or connection information for a broker
##     @details this is only used if the core is automatically created, the broker information will be transferred to the core for connection
##     @param fi the federate info object to alter
##     @param broker a string which defines the connection information for a broker either a name or an address
##     @forcpponly
##    @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##    @endforcpponly
##

proc helicsFederateInfoSetBroker*(fi: helics_federate_info; broker: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetBroker", header: "helics.h".}
## * set the key for a broker connection
##     @details this is only used if the core is automatically created, the broker information will be transferred to the core for connection
##     @param fi the federate info object to alter
##     @param brokerkey a string containing a key for the broker to connect
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetBrokerKey*(fi: helics_federate_info; brokerkey: cstring;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetBrokerKey", header: "helics.h".}
## * set the port to use for the broker
##     @details this is only used if the core is automatically created, the broker information will be transferred to the core for connection
##     this will only be useful for network broker connections
##     @param fi the federate info object to alter
##     @param brokerPort the integer port number to use for connection with a broker
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetBrokerPort*(fi: helics_federate_info; brokerPort: cint;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetBrokerPort", header: "helics.h".}
## * set the local port to use
##     @details this is only used if the core is automatically created, the port information will be transferred to the core for connection
##     @param fi the federate info object to alter
##     @param localPort a string with the port information to use as the local server port can be a number or "auto" or "os_local"
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetLocalPort*(fi: helics_federate_info; localPort: cstring;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetLocalPort", header: "helics.h".}
## * get a property index for use in /ref helicsFederateInfoSetFlagOption, /ref helicsFederateInfoSetTimeProperty,
##     helicsFederateInfoSetIntegerProperty
##     @param val a string with the property name
##     @return an int with the property code (-1) if not a valid property
##

proc helicsGetPropertyIndex*(val: cstring): cint {.cdecl,
    importc: "helicsGetPropertyIndex", header: "helics.h".}
## * get an option index for use in /ref helicsPublicationSetOption, /ref helicsInputSetOption, /ref helicsEndpointSetOption, /ref
##     helicsFilterSetOption, and the corresponding get functions
##     @param val a string with the option name
##     @return an int with the option index (-1) if not a valid property
##

proc helicsGetOptionIndex*(val: cstring): cint {.cdecl,
    importc: "helicsGetOptionIndex", header: "helics.h".}
## * set a flag in the info structure
##     @details valid flags are available /ref helics_federate_flags
##     @param fi the federate info object to alter
##     @param flag a numerical index for a flag
##     @param value the desired value of the flag helics_true or helics_false
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetFlagOption*(fi: helics_federate_info; flag: cint;
                                     value: helics_bool; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateInfoSetFlagOption", header: "helics.h".}
## * set the separator character in the info structure
##     @details the separator character is the separation character for local publications/endpoints in creating their global name
##     for example if the separator character is '/'  then a local endpoint would have a globally reachable name of fedName/localName
##     @param fi the federate info object to alter
##     @param separator the character to use as a separator
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetSeparator*(fi: helics_federate_info; separator: char;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetSeparator", header: "helics.h".}
## * set the output delay for a federate
##     @param fi the federate info object to alter
##     @param timeProperty an integer representation of the time based property to set see /ref helics_properties
##     @param propertyValue the value of the property to set the timeProperty to
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetTimeProperty*(fi: helics_federate_info;
                                       timeProperty: cint;
                                       propertyValue: helics_time;
                                       err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetTimeProperty", header: "helics.h".}
## * set an integer property for a federate
##     @details some known properties are
##     @param fi the federateInfo object to alter
##     @param intProperty an int identifying the property
##     @param propertyValue the value to set the property to
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateInfoSetIntegerProperty*(fi: helics_federate_info;
    intProperty: cint; propertyValue: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetIntegerProperty", header: "helics.h".}
## * load interfaces from a file
##     @param fed the federate to which to load interfaces
##     @param file the name of a file to load the interfaces from either JSON, or TOML
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateRegisterInterfaces*(fed: helics_federate; file: cstring;
                                      err: ptr helics_error) {.cdecl,
    importc: "helicsFederateRegisterInterfaces", header: "helics.h".}
## * generate a global Error from a federate
## A global error halts the co-simulation completely
## @param fed the federate to create an error in
## @param error_code the integer code for the error
## @param error_string a string describing the error
##

proc helicsFederateGlobalError*(fed: helics_federate; error_code: cint;
                               error_string: cstring) {.cdecl,
    importc: "helicsFederateGlobalError", header: "helics.h".}
## * generate a local error in a federate
## this will propagate through the co-simulation but not necessarily halt the co-simulation, it has a similar effect to finalize but does
## allow some interaction with a core for a brief time.
## @param fed the federate to create an error in
## @param error_code the integer code for the error
## @param error_string a string describing the error
##

proc helicsFederateLocalError*(fed: helics_federate; error_code: cint;
                              error_string: cstring) {.cdecl,
    importc: "helicsFederateLocalError", header: "helics.h".}
## * finalize the federate this function halts all communication in the federate and disconnects it from the core
##

proc helicsFederateFinalize*(fed: helics_federate; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateFinalize", header: "helics.h".}
## * finalize the federate in an async call

proc helicsFederateFinalizeAsync*(fed: helics_federate; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateFinalizeAsync", header: "helics.h".}
## * complete the asynchronous finalize call

proc helicsFederateFinalizeComplete*(fed: helics_federate; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateFinalizeComplete", header: "helics.h".}
## * release the memory associated withe a federate

proc helicsFederateFree*(fed: helics_federate) {.cdecl,
    importc: "helicsFederateFree", header: "helics.h".}
## * call when done using the helics library,  this function will ensure the threads are closed properly if possible
##     this should be the last call before exiting,

proc helicsCloseLibrary*() {.cdecl, importc: "helicsCloseLibrary", header: "helics.h".}
##  initialization, execution, and time requests
## * enter the initialization state of a federate
##     @details the initialization state allows initial values to be set and received if the iteration is requested on entry to
##     the execution state
##     This is a blocking call and will block until the core allows it to proceed
##     @param fed the federate to operate on
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateEnterInitializingMode*(fed: helics_federate;
    err: ptr helics_error) {.cdecl, importc: "helicsFederateEnterInitializingMode",
                          header: "helics.h".}
## * non blocking alternative to \ref helicsFederateEnterInitializingMode
##     the function helicsFederateEnterInitializationModeFinalize must be called to finish the operation
##     @param fed the federate to operate on
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateEnterInitializingModeAsync*(fed: helics_federate;
    err: ptr helics_error) {.cdecl,
                          importc: "helicsFederateEnterInitializingModeAsync",
                          header: "helics.h".}
## * check if the current Asynchronous operation has completed
##     @param fed the federate to operate on
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return helics_false if not completed, helics_true if completed

proc helicsFederateIsAsyncOperationCompleted*(fed: helics_federate;
    err: ptr helics_error): helics_bool {.cdecl, importc: "helicsFederateIsAsyncOperationCompleted",
                                      header: "helics.h".}
## * finalize the entry to initialize mode that was initiated with /ref heliceEnterInitializingModeAsync
##     @param fed the federate desiring to complete the initialization step
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateEnterInitializingModeComplete*(fed: helics_federate;
    err: ptr helics_error) {.cdecl, importc: "helicsFederateEnterInitializingModeComplete",
                          header: "helics.h".}
## * request that the federate enter the Execution mode
##     @details this call is blocking until granted entry by the core object for an asynchronous alternative call
##     /ref helicsFederateEnterExecutingModeAsync  on return from this call the federate will be at time 0
##     @param fed a federate to change modes
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateEnterExecutingMode*(fed: helics_federate; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateEnterExecutingMode", header: "helics.h".}
## * request that the federate enter the Execution mode
##     @details this call is non-blocking and will return immediately call /ref helicsFederateEnterExecutingModeComplete to finish the call
##     sequence /ref helicsFederateEnterExecutingModeComplete
##     @param fed the federate object to complete the call
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateEnterExecutingModeAsync*(fed: helics_federate;
    err: ptr helics_error) {.cdecl,
                          importc: "helicsFederateEnterExecutingModeAsync",
                          header: "helics.h".}
## * complete the call to /ref EnterExecutingModeAsync
##     @param fed the federate object to complete the call
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateEnterExecutingModeComplete*(fed: helics_federate;
    err: ptr helics_error) {.cdecl,
                          importc: "helicsFederateEnterExecutingModeComplete",
                          header: "helics.h".}
## * request an iterative time
##     @details this call allows for finer grain control of the iterative process then /ref helicsFederateRequestTime it takes a time and
##     iteration request and return a time and iteration status
##     @param fed the federate to make the request of
##     @param iterate the requested iteration mode
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return an iteration structure with field containing the time and iteration status
##

proc helicsFederateEnterExecutingModeIterative*(fed: helics_federate;
    iterate: helics_iteration_request; err: ptr helics_error): helics_iteration_result {.
    cdecl, importc: "helicsFederateEnterExecutingModeIterative", header: "helics.h".}
## * request an iterative entry to the execution mode
##     @details this call allows for finer grain control of the iterative process then /ref helicsFederateRequestTime it takes a time and and
##     iteration request and return a time and iteration status
##     @param fed the federate to make the request of
##     @param iterate the requested iteration mode
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateEnterExecutingModeIterativeAsync*(fed: helics_federate;
    iterate: helics_iteration_request; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateEnterExecutingModeIterativeAsync", header: "helics.h".}
## * complete the asynchronous iterative call into ExecutionModel
##     @param fed the federate to make the request of
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return an iteration object containing the iteration time and iteration_status
##

proc helicsFederateEnterExecutingModeIterativeComplete*(fed: helics_federate;
    err: ptr helics_error): helics_iteration_result {.cdecl,
    importc: "helicsFederateEnterExecutingModeIterativeComplete",
    header: "helics.h".}
## * get the current state of a federate
##     @param fed the fed to query
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return state the resulting state if void return helics_ok

proc helicsFederateGetState*(fed: helics_federate; err: ptr helics_error): helics_federate_state {.
    cdecl, importc: "helicsFederateGetState", header: "helics.h".}
## * get the core object associated with a federate
##     @param fed a federate object
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a core object, nullptr if invalid
##

proc helicsFederateGetCoreObject*(fed: helics_federate; err: ptr helics_error): helics_core {.
    cdecl, importc: "helicsFederateGetCoreObject", header: "helics.h".}
## * request the next time for federate execution
##     @param fed the federate to make the request of
##     @param requestTime the next requested time
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return the time granted to the federate, will return helics_time_maxtime if the simulation has terminated
##     invalid

proc helicsFederateRequestTime*(fed: helics_federate; requestTime: helics_time;
                               err: ptr helics_error): helics_time {.cdecl,
    importc: "helicsFederateRequestTime", header: "helics.h".}
## * request the next time for federate execution
##     @param fed the federate to make the request of
##     @param timeDelta the requested amount of time to advance
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return the time granted to the federate, will return helics_time_maxtime if the simulation has terminated
##     invalid

proc helicsFederateRequestTimeAdvance*(fed: helics_federate;
                                      timeDelta: helics_time;
                                      err: ptr helics_error): helics_time {.cdecl,
    importc: "helicsFederateRequestTimeAdvance", header: "helics.h".}
## * request the next time step for federate execution
##     @details feds should have setup the period or minDelta for this to work well but it will request the next time step which is the current
##     time plus the minimum time step
##     @param fed the federate to make the request of
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return the time granted to the federate, will return helics_time_maxtime if the simulation has terminated
##     invalid

proc helicsFederateRequestNextStep*(fed: helics_federate; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateRequestNextStep", header: "helics.h".}
## * request an iterative time
##     @details this call allows for finer grain control of the iterative process then /ref helicsFederateRequestTime it takes a time and and
##     iteration request and return a time and iteration status
##     @param fed the federate to make the request of
##     @param requestTime the next desired time
##     @param iterate the requested iteration mode
##     @param[out] outIteration  the iteration specification of the result
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return the granted time, will return helics_time_maxtime if the simulation has terminated along with the appropriate iteration result
##     value
##

proc helicsFederateRequestTimeIterative*(fed: helics_federate;
                                        requestTime: helics_time;
                                        iterate: helics_iteration_request;
    outIteration: ptr helics_iteration_result; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateRequestTimeIterative", header: "helics.h".}
## * request the next time for federate execution in an asynchronous call
##     @details call /ref helicsFederateRequestTimeComplete to finish the call
##     @param fed the federate to make the request of
##     @param requestTime the next requested time
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateRequestTimeAsync*(fed: helics_federate;
                                    requestTime: helics_time;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsFederateRequestTimeAsync", header: "helics.h".}
## * complete an asynchronous requestTime call
##     @param fed the federate to make the request of
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return the time granted to the federate, will return helics_time_maxtime if the simulation has terminated

proc helicsFederateRequestTimeComplete*(fed: helics_federate; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateRequestTimeComplete", header: "helics.h".}
## * request an iterative time through an asynchronous call
##     @details this call allows for finer grain control of the iterative process then /ref helicsFederateRequestTime it takes a time an
##     iteration request and returns a time and iteration status call /ref helicsFederateRequestTimeIterativeComplete to finish the process
##     @param fed the federate to make the request of
##     @param requestTime the next desired time
##     @param iterate the requested iteration mode
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateRequestTimeIterativeAsync*(fed: helics_federate;
    requestTime: helics_time; iterate: helics_iteration_request;
    err: ptr helics_error) {.cdecl,
                          importc: "helicsFederateRequestTimeIterativeAsync",
                          header: "helics.h".}
## * complete an iterative time request asynchronous call
##     @param fed the federate to make the request of
##     @param[out] outIterate  the iteration specification of the result
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return the granted time, will return helics_time_maxtime if the simulation has terminated
##

proc helicsFederateRequestTimeIterativeComplete*(fed: helics_federate;
    outIterate: ptr helics_iteration_result; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateRequestTimeIterativeComplete",
    header: "helics.h".}
## * get the name of the federate
##     @param fed the federate object to query
##     @return a pointer to a string with the name
##

proc helicsFederateGetName*(fed: helics_federate): cstring {.cdecl,
    importc: "helicsFederateGetName", header: "helics.h".}
## * set a time based property for a federate
##     @param fed the federate object set the property for
##     @param timeProperty a integer code for a time property
##     @param time the requested value of the property
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateSetTimeProperty*(fed: helics_federate; timeProperty: cint;
                                   time: helics_time; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateSetTimeProperty", header: "helics.h".}
## * set a flag for the federate
##     @param fed the federate to alter a flag for
##     @param flag the flag to change
##     @param flagValue the new value of the flag 0 for false !=0 for true
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateSetFlagOption*(fed: helics_federate; flag: cint;
                                 flagValue: helics_bool; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateSetFlagOption", header: "helics.h".}
## * set the separator character in a federate
##     @details the separator character is the separation character for local publications/endpoints in creating their global name
##     for example if the separator character is '/'  then a local endpoint would have a globally reachable name of fedName/localName
##     @param fed the federate info object to alter
##     @param separator the character to use as a separator
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateSetSeparator*(fed: helics_federate; separator: char;
                                err: ptr helics_error) {.cdecl,
    importc: "helicsFederateSetSeparator", header: "helics.h".}
## *  set an integer based property of a federate
##     @param fed the federate to change the property for
##     @param intProperty the property to set
##     @param propertyVal the value of the property
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateSetIntegerProperty*(fed: helics_federate; intProperty: cint;
                                      propertyVal: cint; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateSetIntegerProperty", header: "helics.h".}
## * get the current value of a time based property in a federate
##     @param fed the federate query
##     @param timeProperty the property to query
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsFederateGetTimeProperty*(fed: helics_federate; timeProperty: cint;
                                   err: ptr helics_error): helics_time {.cdecl,
    importc: "helicsFederateGetTimeProperty", header: "helics.h".}
## * get a flag value for a federate
##     @param fed the federate to get the flag for
##     @param flag the flag to query
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return the value of the flag
##

proc helicsFederateGetFlagOption*(fed: helics_federate; flag: cint;
                                 err: ptr helics_error): helics_bool {.cdecl,
    importc: "helicsFederateGetFlagOption", header: "helics.h".}
## *  Get the current value of an integer property (such as a logging level)
##     @param fed the federate to get the flag for
##     @param intProperty a code for the property to set /ref helics_handle_options
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return the value of the property
##

proc helicsFederateGetIntegerProperty*(fed: helics_federate; intProperty: cint;
                                      err: ptr helics_error): cint {.cdecl,
    importc: "helicsFederateGetIntegerProperty", header: "helics.h".}
## * get the current time of the federate
##     @param fed the federate object to query
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return the current time of the federate
##

proc helicsFederateGetCurrentTime*(fed: helics_federate; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateGetCurrentTime", header: "helics.h".}
## * set a federation global value through a federate
##     @details this overwrites any previous value for this name
##     @param fed the federate to set the global through
##     @param valueName the name of the global to set
##     @param value the value of the global
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsFederateSetGlobal*(fed: helics_federate; valueName: cstring;
                             value: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateSetGlobal", header: "helics.h".}
## * add a time dependency for a federate.  The federate will depend on the given named federate for time synchronization
##     @param fed the federate to add the dependency for
##     @param fedName the name of the federate to depend on
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsFederateAddDependency*(fed: helics_federate; fedName: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsFederateAddDependency", header: "helics.h".}
## * set the logging file for a federate(actually on the core associated with a federate)
##     @param fed the federate to set the log file for
##     @param logFile the name of the log file
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsFederateSetLogFile*(fed: helics_federate; logFile: cstring;
                              err: ptr helics_error) {.cdecl,
    importc: "helicsFederateSetLogFile", header: "helics.h".}
## * log an error message through a federate
##     @param fed the federate to set the global through
##     @param logmessage the message to put in the log
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsFederateLogErrorMessage*(fed: helics_federate; logmessage: cstring;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFederateLogErrorMessage", header: "helics.h".}
## * log a warning message through a federate
##     @param fed the federate to set the global through
##     @param logmessage the message to put in the log
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsFederateLogWarningMessage*(fed: helics_federate; logmessage: cstring;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsFederateLogWarningMessage", header: "helics.h".}
## * log a message through a federate
##     @param fed the federate to set the global through
##     @param logmessage the message to put in the log
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsFederateLogInfoMessage*(fed: helics_federate; logmessage: cstring;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsFederateLogInfoMessage", header: "helics.h".}
## * log a message through a federate
##     @param fed the federate to set the global through
##     @param logmessage the message to put in the log
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsFederateLogDebugMessage*(fed: helics_federate; logmessage: cstring;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFederateLogDebugMessage", header: "helics.h".}
## * log a message through a federate
##     @param fed the federate to set the global through
##     @param loglevel the level of the message to log see /ref helics_log_levels
##     @param logmessage the message to put in the log
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsFederateLogLevelMessage*(fed: helics_federate; loglevel: cint;
                                   logmessage: cstring; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateLogLevelMessage", header: "helics.h".}
## * set a global value in a core
##     @details this overwrites any previous value for this name
##     @param core the core to set the global through
##     @param valueName the name of the global to set
##     @param value the value of the global
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsCoreSetGlobal*(core: helics_core; valueName: cstring; value: cstring;
                         err: ptr helics_error) {.cdecl,
    importc: "helicsCoreSetGlobal", header: "helics.h".}
## * set a federation global value
##     @details this overwrites any previous value for this name
##     @param broker the broker to set the global through
##     @param valueName the name of the global to set
##     @param value the value of the global
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsBrokerSetGlobal*(broker: helics_broker; valueName: cstring;
                           value: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerSetGlobal", header: "helics.h".}
## * set a the log file on a core
##     @param core the core to set the global through
##     @param logFileName the name of the file to log to
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsCoreSetLogFile*(core: helics_core; logFileName: cstring;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsCoreSetLogFile", header: "helics.h".}
## * set a the log file on a broker
##     @param broker the broker to set the global through
##     @param logFileName the name of the file to log to
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsBrokerSetLogFile*(broker: helics_broker; logFileName: cstring;
                            err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerSetLogFile", header: "helics.h".}
## * create a query object
##     @details a query object consists of a target and query string
##     @param target the name of the target to query
##     @param query the query to make of the target
##

proc helicsCreateQuery*(target: cstring; query: cstring): helics_query {.cdecl,
    importc: "helicsCreateQuery", header: "helics.h".}
## * Execute a query
##     @details the call will block until the query finishes which may require communication or other delays
##     @param query the query object to use in the query
##     @param fed a federate to send the query through
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a pointer to a string.  the string will remain valid until the query is freed or executed again
##     the return will be nullptr if fed or query is an invalid object, the return string will be "#invalid" if the query itself was invalid
##

proc helicsQueryExecute*(query: helics_query; fed: helics_federate;
                        err: ptr helics_error): cstring {.cdecl,
    importc: "helicsQueryExecute", header: "helics.h".}
## * Execute a query directly on a core
##     @details the call will block until the query finishes which may require communication or other delays
##     @param query the query object to use in the query
##     @param core the core to send the query to
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a pointer to a string.  the string will remain valid until the query is freed or executed again
##     the return will be nullptr if fed or query is an invalid object, the return string will be "#invalid" if the query itself was invalid
##

proc helicsQueryCoreExecute*(query: helics_query; core: helics_core;
                            err: ptr helics_error): cstring {.cdecl,
    importc: "helicsQueryCoreExecute", header: "helics.h".}
## * Execute a query directly on a broker
##     @details the call will block until the query finishes which may require communication or other delays
##     @param query the query object to use in the query
##     @param broker the broker to send the query to
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a pointer to a string.  the string will remain valid until the query is freed or executed again
##     the return will be nullptr if fed or query is an invalid object, the return string will be "#invalid" if the query itself was invalid
##

proc helicsQueryBrokerExecute*(query: helics_query; broker: helics_broker;
                              err: ptr helics_error): cstring {.cdecl,
    importc: "helicsQueryBrokerExecute", header: "helics.h".}
## * Execute a query in a non-blocking call
##     @param query the query object to use in the query
##     @param fed a federate to send the query through
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsQueryExecuteAsync*(query: helics_query; fed: helics_federate;
                             err: ptr helics_error) {.cdecl,
    importc: "helicsQueryExecuteAsync", header: "helics.h".}
## * complete the return from a query called with /ref helicsExecuteQueryAsync
##     @details the function will block until the query completes /ref isQueryComplete can be called to determine if a query has completed or
##     not
##     @param query the query object to complete execution of
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##     @return a pointer to a string.  the string will remain valid until the query is freed or executed again
##     the return will be nullptr if query is an invalid object
##

proc helicsQueryExecuteComplete*(query: helics_query; err: ptr helics_error): cstring {.
    cdecl, importc: "helicsQueryExecuteComplete", header: "helics.h".}
## * check if an asynchronously executed query has completed
##     @details this function should usually be called after a QueryExecuteAsync function has been called
##     @param query the query object to check if completed
##     @return will return helics_true if an asynchronous query has complete or a regular query call was made with a result
##     and false if an asynchronous query has not completed or is invalid
##

proc helicsQueryIsCompleted*(query: helics_query): helics_bool {.cdecl,
    importc: "helicsQueryIsCompleted", header: "helics.h".}
## * free the memory associated with a query object

proc helicsQueryFree*(query: helics_query) {.cdecl, importc: "helicsQueryFree",
    header: "helics.h".}
## * function to do some housekeeping work
##     @details this runs some cleanup routines and tries to close out any residual thread that haven't been shutdown
##     yet

proc helicsCleanupLibrary*() {.cdecl, importc: "helicsCleanupLibrary",
                             header: "helics.h".}
