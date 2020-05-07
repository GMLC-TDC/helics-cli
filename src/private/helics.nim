##
## Copyright (c) 2017-2020,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##

import
  api-data

import
  helics_export

## *
##  @file
##  @brief Common functions for the HELICS C api.
##
## **************************************************
##  Common Functions
## *************************************************
## *
##  Get a version string for HELICS.
##

proc helicsGetVersion*(): cstring {.cdecl, importc: "helicsGetVersion",
                                 dynlib: helicsSharedLib.}
## *
##  Return an initialized error object.
##

proc helicsErrorInitialize*(): helics_error {.cdecl,
    importc: "helicsErrorInitialize", dynlib: helicsSharedLib.}
## *
##  Clear an error object.
##

proc helicsErrorClear*(err: ptr helics_error) {.cdecl, importc: "helicsErrorClear",
    dynlib: helicsSharedLib.}
## *
##  Returns true if core/broker type specified is available in current compilation.
##
##  @param type A string representing a core type.
##
##  @details Options include "zmq", "udp", "ipc", "interprocess", "tcp", "default", "mpi".
##

proc helicsIsCoreTypeAvailable*(`type`: cstring): helics_bool {.cdecl,
    importc: "helicsIsCoreTypeAvailable", dynlib: helicsSharedLib.}
## *
##  Create a core object.
##
##  @param type The type of the core to create.
##  @param name The name of the core. It can be a nullptr or empty string to have a name automatically assigned.
##  @param initString An initialization string to send to the core. The format is similar to command line arguments.
##                    Typical options include a broker name, the broker address, the number of federates, etc.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A helics_core object.
##  @forcpponly
##  If the core is invalid, err will contain the corresponding error message and the returned object will be NULL.
##  @endforcpponly
##

proc helicsCreateCore*(`type`: cstring; name: cstring; initString: cstring;
                      err: ptr helics_error): helics_core {.cdecl,
    importc: "helicsCreateCore", dynlib: helicsSharedLib.}
## *
##  Create a core object by passing command line arguments.
##
##  @param type The type of the core to create.
##  @param name The name of the core. It can be a nullptr or empty string to have a name automatically assigned.
##  @forcpponly
##  @param argc The number of arguments.
##  @endforcpponly
##  @param argv The list of string values from a command line.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string
##                     if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A helics_core object.
##

proc helicsCreateCoreFromArgs*(`type`: cstring; name: cstring; argc: cint;
                              argv: cstringArray; err: ptr helics_error): helics_core {.
    cdecl, importc: "helicsCreateCoreFromArgs", dynlib: helicsSharedLib.}
## *
##  Create a new reference to an existing core.
##
##  @details This will create a new broker object that references the existing broker. The new broker object must be freed as well.
##
##  @param core An existing helics_core.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A new reference to the same broker.
##

proc helicsCoreClone*(core: helics_core; err: ptr helics_error): helics_core {.cdecl,
    importc: "helicsCoreClone", dynlib: helicsSharedLib.}
## *
##  Check if a core object is a valid object.
##
##  @param core The helics_core object to test.
##

proc helicsCoreIsValid*(core: helics_core): helics_bool {.cdecl,
    importc: "helicsCoreIsValid", dynlib: helicsSharedLib.}
## *
##  Create a broker object.
##
##  @param type The type of the broker to create.
##  @param name The name of the broker. It can be a nullptr or empty string to have a name automatically assigned.
##  @param initString An initialization string to send to the core-the format is similar to command line arguments.
##                    Typical options include a broker address such as --broker="XSSAF" if this is a subbroker, or the number of federates, or the address.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A helics_broker object.
##  @forcpponly
##  It will be NULL if there was an error indicated in the err object.
##  @endforcpponly
##

proc helicsCreateBroker*(`type`: cstring; name: cstring; initString: cstring;
                        err: ptr helics_error): helics_broker {.cdecl,
    importc: "helicsCreateBroker", dynlib: helicsSharedLib.}
## *
##  Create a core object by passing command line arguments.
##
##  @param type The type of the core to create.
##  @param name The name of the core. It can be a nullptr or empty string to have a name automatically assigned.
##  @forcpponly
##  @param argc The number of arguments.
##  @endforcpponly
##  @param argv The list of string values from a command line.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A helics_core object.
##

proc helicsCreateBrokerFromArgs*(`type`: cstring; name: cstring; argc: cint;
                                argv: cstringArray; err: ptr helics_error): helics_broker {.
    cdecl, importc: "helicsCreateBrokerFromArgs", dynlib: helicsSharedLib.}
## *
##  Create a new reference to an existing broker.
##
##  @details This will create a new broker object that references the existing broker it must be freed as well.
##
##  @param broker An existing helics_broker.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A new reference to the same broker.
##

proc helicsBrokerClone*(broker: helics_broker; err: ptr helics_error): helics_broker {.
    cdecl, importc: "helicsBrokerClone", dynlib: helicsSharedLib.}
## *
##  Check if a broker object is a valid object.
##
##  @param broker The helics_broker object to test.
##

proc helicsBrokerIsValid*(broker: helics_broker): helics_bool {.cdecl,
    importc: "helicsBrokerIsValid", dynlib: helicsSharedLib.}
## *
##  Check if a broker is connected.
##
##  @details A connected broker implies it is attached to cores or cores could reach out to communicate.
##
##  @return helics_false if not connected.
##

proc helicsBrokerIsConnected*(broker: helics_broker): helics_bool {.cdecl,
    importc: "helicsBrokerIsConnected", dynlib: helicsSharedLib.}
## *
##  Link a named publication and named input using a broker.
##
##  @param broker The broker to generate the connection from.
##  @param source The name of the publication (cannot be NULL).
##  @param target The name of the target to send the publication data (cannot be NULL).
##  @forcpponly
##  @param[in,out] err A helics_error object, can be NULL if the errors are to be ignored.
##  @endforcpponly
##

proc helicsBrokerDataLink*(broker: helics_broker; source: cstring; target: cstring;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerDataLink", dynlib: helicsSharedLib.}
## *
##  Link a named filter to a source endpoint.
##
##  @param broker The broker to generate the connection from.
##  @param filter The name of the filter (cannot be NULL).
##  @param endpoint The name of the endpoint to filter the data from (cannot be NULL).
##  @forcpponly
##  @param[in,out] err A helics_error object, can be NULL if the errors are to be ignored.
##  @endforcpponly
##

proc helicsBrokerAddSourceFilterToEndpoint*(broker: helics_broker; filter: cstring;
    endpoint: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerAddSourceFilterToEndpoint", dynlib: helicsSharedLib.}
## *
##  Link a named filter to a destination endpoint.
##
##  @param broker The broker to generate the connection from.
##  @param filter The name of the filter (cannot be NULL).
##  @param endpoint The name of the endpoint to filter the data going to (cannot be NULL).
##  @forcpponly
##  @param[in,out] err A helics_error object, can be NULL if the errors are to be ignored.
##  @endforcpponly
##

proc helicsBrokerAddDestinationFilterToEndpoint*(broker: helics_broker;
    filter: cstring; endpoint: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerAddDestinationFilterToEndpoint", dynlib: helicsSharedLib.}
## *
##  Load a file containing connection information.
##
##  @param broker The broker to generate the connections from.
##  @param file A JSON or TOML file containing connection information.
##  @forcpponly
##  @param[in,out] err A helics_error object, can be NULL if the errors are to be ignored.
##  @endforcpponly
##

proc helicsBrokerMakeConnections*(broker: helics_broker; file: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerMakeConnections", dynlib: helicsSharedLib.}
## *
##  Wait for the core to disconnect.
##
##  @param core The core to wait for.
##  @param msToWait The time out in millisecond (<0 for infinite timeout).
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return helics_true if the disconnect was successful, helics_false if there was a timeout.
##

proc helicsCoreWaitForDisconnect*(core: helics_core; msToWait: cint;
                                 err: ptr helics_error): helics_bool {.cdecl,
    importc: "helicsCoreWaitForDisconnect", dynlib: helicsSharedLib.}
## *
##  Wait for the broker to disconnect.
##
##  @param broker The broker to wait for.
##  @param msToWait The time out in millisecond (<0 for infinite timeout).
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return helics_true if the disconnect was successful, helics_false if there was a timeout.
##

proc helicsBrokerWaitForDisconnect*(broker: helics_broker; msToWait: cint;
                                   err: ptr helics_error): helics_bool {.cdecl,
    importc: "helicsBrokerWaitForDisconnect", dynlib: helicsSharedLib.}
## *
##  Check if a core is connected.
##
##  @details A connected core implies it is attached to federates or federates could be attached to it
##
##  @return helics_false if not connected, helics_true if it is connected.
##

proc helicsCoreIsConnected*(core: helics_core): helics_bool {.cdecl,
    importc: "helicsCoreIsConnected", dynlib: helicsSharedLib.}
## *
##  Link a named publication and named input using a core.
##
##  @param core The core to generate the connection from.
##  @param source The name of the publication (cannot be NULL).
##  @param target The name of the target to send the publication data (cannot be NULL).
##  @forcpponly
##  @param[in,out] err A helics_error object, can be NULL if the errors are to be ignored.
##  @endforcpponly
##

proc helicsCoreDataLink*(core: helics_core; source: cstring; target: cstring;
                        err: ptr helics_error) {.cdecl,
    importc: "helicsCoreDataLink", dynlib: helicsSharedLib.}
## *
##  Link a named filter to a source endpoint.
##
##  @param core The core to generate the connection from.
##  @param filter The name of the filter (cannot be NULL).
##  @param endpoint The name of the endpoint to filter the data from (cannot be NULL).
##  @forcpponly
##  @param[in,out] err A helics_error object, can be NULL if the errors are to be ignored.
##  @endforcpponly
##

proc helicsCoreAddSourceFilterToEndpoint*(core: helics_core; filter: cstring;
    endpoint: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreAddSourceFilterToEndpoint", dynlib: helicsSharedLib.}
## *
##  Link a named filter to a destination endpoint.
##
##  @param core The core to generate the connection from.
##  @param filter The name of the filter (cannot be NULL).
##  @param endpoint The name of the endpoint to filter the data going to (cannot be NULL).
##  @forcpponly
##  @param[in,out] err A helics_error object, can be NULL if the errors are to be ignored.
##  @endforcpponly
##

proc helicsCoreAddDestinationFilterToEndpoint*(core: helics_core; filter: cstring;
    endpoint: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreAddDestinationFilterToEndpoint", dynlib: helicsSharedLib.}
## *
##  Load a file containing connection information.
##
##  @param core The core to generate the connections from.
##  @param file A JSON or TOML file containing connection information.
##  @forcpponly
##  @param[in,out] err A helics_error object, can be NULL if the errors are to be ignored.
##  @endforcpponly
##

proc helicsCoreMakeConnections*(core: helics_core; file: cstring;
                               err: ptr helics_error) {.cdecl,
    importc: "helicsCoreMakeConnections", dynlib: helicsSharedLib.}
## *
##  Get an identifier for the broker.
##
##  @param broker The broker to query.
##
##  @return A string containing the identifier for the broker.
##

proc helicsBrokerGetIdentifier*(broker: helics_broker): cstring {.cdecl,
    importc: "helicsBrokerGetIdentifier", dynlib: helicsSharedLib.}
## *
##  Get an identifier for the core.
##
##  @param core The core to query.
##
##  @return A string with the identifier of the core.
##

proc helicsCoreGetIdentifier*(core: helics_core): cstring {.cdecl,
    importc: "helicsCoreGetIdentifier", dynlib: helicsSharedLib.}
## *
##  Get the network address associated with a broker.
##
##  @param broker The broker to query.
##
##  @return A string with the network address of the broker.
##

proc helicsBrokerGetAddress*(broker: helics_broker): cstring {.cdecl,
    importc: "helicsBrokerGetAddress", dynlib: helicsSharedLib.}
## *
##  Get the network address associated with a core.
##
##  @param core The core to query.
##
##  @return A string with the network address of the broker.
##

proc helicsCoreGetAddress*(core: helics_core): cstring {.cdecl,
    importc: "helicsCoreGetAddress", dynlib: helicsSharedLib.}
## *
##  Set the core to ready for init.
##
##  @details This function is used for cores that have filters but no federates so there needs to be
##           a direct signal to the core to trigger the federation initialization.
##
##  @param core The core object to enable init values for.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsCoreSetReadyToInit*(core: helics_core; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreSetReadyToInit", dynlib: helicsSharedLib.}
## *
##  Connect a core to the federate based on current configuration.
##
##  @param core The core to connect.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return helics_false if not connected, helics_true if it is connected.
##

proc helicsCoreConnect*(core: helics_core; err: ptr helics_error): helics_bool {.cdecl,
    importc: "helicsCoreConnect", dynlib: helicsSharedLib.}
## *
##  Disconnect a core from the federation.
##
##  @param core The core to query.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsCoreDisconnect*(core: helics_core; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreDisconnect", dynlib: helicsSharedLib.}
## *
##  Get an existing federate object from a core by name.
##
##  @details The federate must have been created by one of the other functions and at least one of the objects referencing the created
##           federate must still be active in the process.
##
##  @param fedName The name of the federate to retrieve.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return NULL if no fed is available by that name otherwise a helics_federate with that name.
##

proc helicsGetFederateByName*(fedName: cstring; err: ptr helics_error): helics_federate {.
    cdecl, importc: "helicsGetFederateByName", dynlib: helicsSharedLib.}
## *
##  Disconnect a broker.
##
##  @param broker The broker to disconnect.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsBrokerDisconnect*(broker: helics_broker; err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerDisconnect", dynlib: helicsSharedLib.}
## *
##  Disconnect and free a federate.
##

proc helicsFederateDestroy*(fed: helics_federate) {.cdecl,
    importc: "helicsFederateDestroy", dynlib: helicsSharedLib.}
## *
##  Disconnect and free a broker.
##

proc helicsBrokerDestroy*(broker: helics_broker) {.cdecl,
    importc: "helicsBrokerDestroy", dynlib: helicsSharedLib.}
## *
##  Disconnect and free a core.
##

proc helicsCoreDestroy*(core: helics_core) {.cdecl, importc: "helicsCoreDestroy",
    dynlib: helicsSharedLib.}
## *
##  Release the memory associated with a core.
##

proc helicsCoreFree*(core: helics_core) {.cdecl, importc: "helicsCoreFree",
                                       dynlib: helicsSharedLib.}
## *
##  Release the memory associated with a broker.
##

proc helicsBrokerFree*(broker: helics_broker) {.cdecl, importc: "helicsBrokerFree",
    dynlib: helicsSharedLib.}
##
##  Creation and destruction of Federates.
##
## *
##  Create a value federate from a federate info object.
##
##  @details helics_federate objects can be used in all functions that take a helics_federate or helics_federate object as an argument.
##
##  @param fedName The name of the federate to create, can NULL or an empty string to use the default name from fi or an assigned name.
##  @param fi The federate info object that contains details on the federate.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return An opaque value federate object.
##

proc helicsCreateValueFederate*(fedName: cstring; fi: helics_federate_info;
                               err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateValueFederate", dynlib: helicsSharedLib.}
## *
##  Create a value federate from a JSON file, JSON string, or TOML file.
##
##  @details helics_federate objects can be used in all functions that take a helics_federate or helics_federate object as an argument.
##
##  @param configFile A JSON file or a JSON string or TOML file that contains setup and configuration information.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return An opaque value federate object.
##

proc helicsCreateValueFederateFromConfig*(configFile: cstring;
    err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateValueFederateFromConfig", dynlib: helicsSharedLib.}
## *
##  Create a message federate from a federate info object.
##
##  @details helics_message_federate objects can be used in all functions that take a helics_message_federate or helics_federate object as an argument.
##
##  @param fedName The name of the federate to create.
##  @param fi The federate info object that contains details on the federate.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return An opaque message federate object.
##

proc helicsCreateMessageFederate*(fedName: cstring; fi: helics_federate_info;
                                 err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateMessageFederate", dynlib: helicsSharedLib.}
## *
##  Create a message federate from a JSON file or JSON string or TOML file.
##
##  @details helics_message_federate objects can be used in all functions that take a helics_message_federate or helics_federate object as an argument.
##
##  @param configFile A Config(JSON,TOML) file or a JSON string that contains setup and configuration information.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return An opaque message federate object.
##

proc helicsCreateMessageFederateFromConfig*(configFile: cstring;
    err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateMessageFederateFromConfig", dynlib: helicsSharedLib.}
## *
##  Create a combination federate from a federate info object.
##
##  @details Combination federates are both value federates and message federates, objects can be used in all functions
##                       that take a helics_federate, helics_message_federate or helics_federate object as an argument
##
##  @param fedName A string with the name of the federate, can be NULL or an empty string to pull the default name from fi.
##  @param fi The federate info object that contains details on the federate.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return An opaque value federate object nullptr if the object creation failed.
##

proc helicsCreateCombinationFederate*(fedName: cstring; fi: helics_federate_info;
                                     err: ptr helics_error): helics_federate {.
    cdecl, importc: "helicsCreateCombinationFederate", dynlib: helicsSharedLib.}
## *
##  Create a combination federate from a JSON file or JSON string or TOML file.
##
##  @details Combination federates are both value federates and message federates, objects can be used in all functions
##           that take a helics_federate, helics_message_federate or helics_federate object as an argument
##
##  @param configFile A JSON file or a JSON string or TOML file that contains setup and configuration information.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return An opaque combination federate object.
##

proc helicsCreateCombinationFederateFromConfig*(configFile: cstring;
    err: ptr helics_error): helics_federate {.cdecl,
    importc: "helicsCreateCombinationFederateFromConfig", dynlib: helicsSharedLib.}
## *
##  Create a new reference to an existing federate.
##
##  @details This will create a new helics_federate object that references the existing federate. The new object must be freed as well.
##
##  @param fed An existing helics_federate.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A new reference to the same federate.
##

proc helicsFederateClone*(fed: helics_federate; err: ptr helics_error): helics_federate {.
    cdecl, importc: "helicsFederateClone", dynlib: helicsSharedLib.}
## *
##  Create a federate info object for specifying federate information when constructing a federate.
##
##  @return A helics_federate_info object which is a reference to the created object.
##

proc helicsCreateFederateInfo*(): helics_federate_info {.cdecl,
    importc: "helicsCreateFederateInfo", dynlib: helicsSharedLib.}
## *
##  Create a federate info object from an existing one and clone the information.
##
##  @param fi A federateInfo object to duplicate.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##   @return A helics_federate_info object which is a reference to the created object.
##

proc helicsFederateInfoClone*(fi: helics_federate_info; err: ptr helics_error): helics_federate_info {.
    cdecl, importc: "helicsFederateInfoClone", dynlib: helicsSharedLib.}
## *
##  Load federate info from command line arguments.
##
##  @param fi A federateInfo object.
##  @param argc The number of command line arguments.
##  @param argv An array of strings from the command line.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoLoadFromArgs*(fi: helics_federate_info; argc: cint;
                                    argv: cstringArray; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateInfoLoadFromArgs", dynlib: helicsSharedLib.}
## *
##  Delete the memory associated with a federate info object.
##

proc helicsFederateInfoFree*(fi: helics_federate_info) {.cdecl,
    importc: "helicsFederateInfoFree", dynlib: helicsSharedLib.}
## *
##  Check if a federate_object is valid.
##
##  @return helics_true if the federate is a valid active federate, helics_false otherwise
##

proc helicsFederateIsValid*(fed: helics_federate): helics_bool {.cdecl,
    importc: "helicsFederateIsValid", dynlib: helicsSharedLib.}
## *
##  Set the name of the core to link to for a federate.
##
##  @param fi The federate info object to alter.
##  @param corename The identifier for a core to link to.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetCoreName*(fi: helics_federate_info; corename: cstring;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetCoreName", dynlib: helicsSharedLib.}
## *
##  Set the initialization string for the core usually in the form of command line arguments.
##
##  @param fi The federate info object to alter.
##  @param coreInit A string containing command line arguments to be passed to the core.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetCoreInitString*(fi: helics_federate_info;
    coreInit: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetCoreInitString", dynlib: helicsSharedLib.}
## *
##  Set the initialization string that a core will pass to a generated broker usually in the form of command line arguments.
##
##  @param fi The federate info object to alter.
##  @param brokerInit A string with command line arguments for a generated broker.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetBrokerInitString*(fi: helics_federate_info;
    brokerInit: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetBrokerInitString", dynlib: helicsSharedLib.}
## *
##  Set the core type by integer code.
##
##  @details Valid values available by definitions in api-data.h.
##  @param fi The federate info object to alter.
##  @param coretype An numerical code for a core type see /ref helics_core_type.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetCoreType*(fi: helics_federate_info; coretype: cint;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetCoreType", dynlib: helicsSharedLib.}
## *
##  Set the core type from a string.
##
##  @param fi The federate info object to alter.
##  @param coretype A string naming a core type.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetCoreTypeFromString*(fi: helics_federate_info;
    coretype: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetCoreTypeFromString", dynlib: helicsSharedLib.}
## *
##  Set the name or connection information for a broker.
##
##  @details This is only used if the core is automatically created, the broker information will be transferred to the core for connection.
##  @param fi The federate info object to alter.
##  @param broker A string which defines the connection information for a broker either a name or an address.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetBroker*(fi: helics_federate_info; broker: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetBroker", dynlib: helicsSharedLib.}
## *
##  Set the key for a broker connection.
##
##  @details This is only used if the core is automatically created, the broker information will be transferred to the core for connection.
##  @param fi The federate info object to alter.
##  @param brokerkey A string containing a key for the broker to connect.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetBrokerKey*(fi: helics_federate_info; brokerkey: cstring;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetBrokerKey", dynlib: helicsSharedLib.}
## *
##  Set the port to use for the broker.
##
##  @details This is only used if the core is automatically created, the broker information will be transferred to the core for connection.
##  This will only be useful for network broker connections.
##  @param fi The federate info object to alter.
##  @param brokerPort The integer port number to use for connection with a broker.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetBrokerPort*(fi: helics_federate_info; brokerPort: cint;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetBrokerPort", dynlib: helicsSharedLib.}
## *
##  Set the local port to use.
##
##  @details This is only used if the core is automatically created, the port information will be transferred to the core for connection.
##  @param fi The federate info object to alter.
##  @param localPort A string with the port information to use as the local server port can be a number or "auto" or "os_local".
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetLocalPort*(fi: helics_federate_info; localPort: cstring;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetLocalPort", dynlib: helicsSharedLib.}
## *
##  Get a property index for use in /ref helicsFederateInfoSetFlagOption, /ref helicsFederateInfoSetTimeProperty,
##  or /ref helicsFederateInfoSetIntegerProperty
##  @param val A string with the property name.
##  @return An int with the property code or (-1) if not a valid property.
##

proc helicsGetPropertyIndex*(val: cstring): cint {.cdecl,
    importc: "helicsGetPropertyIndex", dynlib: helicsSharedLib.}
## *
##  Get an option index for use in /ref helicsPublicationSetOption, /ref helicsInputSetOption, /ref helicsEndpointSetOption,
##  /ref helicsFilterSetOption, and the corresponding get functions.
##
##  @param val A string with the option name.
##
##  @return An int with the option index or (-1) if not a valid property.
##

proc helicsGetOptionIndex*(val: cstring): cint {.cdecl,
    importc: "helicsGetOptionIndex", dynlib: helicsSharedLib.}
## *
##  Set a flag in the info structure.
##
##  @details Valid flags are available /ref helics_federate_flags.
##  @param fi The federate info object to alter.
##  @param flag A numerical index for a flag.
##  @param value The desired value of the flag helics_true or helics_false.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetFlagOption*(fi: helics_federate_info; flag: cint;
                                     value: helics_bool; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateInfoSetFlagOption", dynlib: helicsSharedLib.}
## *
##  Set the separator character in the info structure.
##
##  @details The separator character is the separation character for local publications/endpoints in creating their global name.
##  For example if the separator character is '/'  then a local endpoint would have a globally reachable name of fedName/localName.
##  @param fi The federate info object to alter.
##  @param separator The character to use as a separator.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetSeparator*(fi: helics_federate_info; separator: char;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetSeparator", dynlib: helicsSharedLib.}
## *
##  Set the output delay for a federate.
##
##  @param fi The federate info object to alter.
##  @param timeProperty An integer representation of the time based property to set see /ref helics_properties.
##  @param propertyValue The value of the property to set the timeProperty to.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetTimeProperty*(fi: helics_federate_info;
                                       timeProperty: cint;
                                       propertyValue: helics_time;
                                       err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetTimeProperty", dynlib: helicsSharedLib.}
##  TODO(Dheepak): what are known properties. The docstring should reference all properties that can be passed here.
## *
##  Set an integer property for a federate.
##
##  @details Set known properties.
##
##  @param fi The federateInfo object to alter.
##  @param intProperty An int identifying the property.
##  @param propertyValue The value to set the property to.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateInfoSetIntegerProperty*(fi: helics_federate_info;
    intProperty: cint; propertyValue: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateInfoSetIntegerProperty", dynlib: helicsSharedLib.}
## *
##  Load interfaces from a file.
##
##  @param fed The federate to which to load interfaces.
##  @param file The name of a file to load the interfaces from either JSON, or TOML.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateRegisterInterfaces*(fed: helics_federate; file: cstring;
                                      err: ptr helics_error) {.cdecl,
    importc: "helicsFederateRegisterInterfaces", dynlib: helicsSharedLib.}
## *
##  Generate a global error from a federate.
##
##  @details A global error halts the co-simulation completely.
##
##  @param fed The federate to create an error in.
##  @param error_code The integer code for the error.
##  @param error_string A string describing the error.
##

proc helicsFederateGlobalError*(fed: helics_federate; error_code: cint;
                               error_string: cstring) {.cdecl,
    importc: "helicsFederateGlobalError", dynlib: helicsSharedLib.}
## *
##  Generate a local error in a federate.
##
##  @details This will propagate through the co-simulation but not necessarily halt the co-simulation, it has a similar effect to finalize but does
##           allow some interaction with a core for a brief time.
##  @param fed The federate to create an error in.
##  @param error_code The integer code for the error.
##  @param error_string A string describing the error.
##

proc helicsFederateLocalError*(fed: helics_federate; error_code: cint;
                              error_string: cstring) {.cdecl,
    importc: "helicsFederateLocalError", dynlib: helicsSharedLib.}
## *
##  Finalize the federate. This function halts all communication in the federate and disconnects it from the core.
##

proc helicsFederateFinalize*(fed: helics_federate; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateFinalize", dynlib: helicsSharedLib.}
## *
##  Finalize the federate in an async call.
##

proc helicsFederateFinalizeAsync*(fed: helics_federate; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateFinalizeAsync", dynlib: helicsSharedLib.}
## *
##  Complete the asynchronous finalize call.
##

proc helicsFederateFinalizeComplete*(fed: helics_federate; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateFinalizeComplete", dynlib: helicsSharedLib.}
## *
##  Release the memory associated withe a federate.
##

proc helicsFederateFree*(fed: helics_federate) {.cdecl,
    importc: "helicsFederateFree", dynlib: helicsSharedLib.}
## *
##  Call when done using the helics library.
##  This function will ensure the threads are closed properly. If possible this should be the last call before exiting.
##

proc helicsCloseLibrary*() {.cdecl, importc: "helicsCloseLibrary",
                           dynlib: helicsSharedLib.}
##
##  Initialization, execution, and time requests.
##
## *
##  Enter the initialization state of a federate.
##
##  @details The initialization state allows initial values to be set and received if the iteration is requested on entry to the execution state.
##           This is a blocking call and will block until the core allows it to proceed.
##
##  @param fed The federate to operate on.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateEnterInitializingMode*(fed: helics_federate;
    err: ptr helics_error) {.cdecl, importc: "helicsFederateEnterInitializingMode",
                          dynlib: helicsSharedLib.}
## *
##  Non blocking alternative to \ref helicsFederateEnterInitializingMode.
##
##  @details The function helicsFederateEnterInitializationModeFinalize must be called to finish the operation.
##
##  @param fed The federate to operate on.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateEnterInitializingModeAsync*(fed: helics_federate;
    err: ptr helics_error) {.cdecl,
                          importc: "helicsFederateEnterInitializingModeAsync",
                          dynlib: helicsSharedLib.}
## *
##  Check if the current Asynchronous operation has completed.
##
##  @param fed The federate to operate on.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return helics_false if not completed, helics_true if completed.
##

proc helicsFederateIsAsyncOperationCompleted*(fed: helics_federate;
    err: ptr helics_error): helics_bool {.cdecl, importc: "helicsFederateIsAsyncOperationCompleted",
                                      dynlib: helicsSharedLib.}
## *
##  Finalize the entry to initialize mode that was initiated with /ref heliceEnterInitializingModeAsync.
##
##  @param fed The federate desiring to complete the initialization step.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateEnterInitializingModeComplete*(fed: helics_federate;
    err: ptr helics_error) {.cdecl, importc: "helicsFederateEnterInitializingModeComplete",
                          dynlib: helicsSharedLib.}
## *
##  Request that the federate enter the Execution mode.
##
##  @details This call is blocking until granted entry by the core object. On return from this call the federate will be at time 0.
##           For an asynchronous alternative call see /ref helicsFederateEnterExecutingModeAsync.
##
##  @param fed A federate to change modes.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateEnterExecutingMode*(fed: helics_federate; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateEnterExecutingMode", dynlib: helicsSharedLib.}
## *
##  Request that the federate enter the Execution mode.
##
##  @details This call is non-blocking and will return immediately. Call /ref helicsFederateEnterExecutingModeComplete to finish the call sequence.
##
##  @param fed The federate object to complete the call.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateEnterExecutingModeAsync*(fed: helics_federate;
    err: ptr helics_error) {.cdecl,
                          importc: "helicsFederateEnterExecutingModeAsync",
                          dynlib: helicsSharedLib.}
## *
##  Complete the call to /ref helicsFederateEnterExecutingModeAsync.
##
##  @param fed The federate object to complete the call.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateEnterExecutingModeComplete*(fed: helics_federate;
    err: ptr helics_error) {.cdecl,
                          importc: "helicsFederateEnterExecutingModeComplete",
                          dynlib: helicsSharedLib.}
## *
##  Request an iterative time.
##
##  @details This call allows for finer grain control of the iterative process than /ref helicsFederateRequestTime. It takes a time and
##           iteration request, and returns a time and iteration status.
##
##  @param fed The federate to make the request of.
##  @param iterate The requested iteration mode.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return An iteration structure with field containing the time and iteration status.
##

proc helicsFederateEnterExecutingModeIterative*(fed: helics_federate;
    iterate: helics_iteration_request; err: ptr helics_error): helics_iteration_result {.
    cdecl, importc: "helicsFederateEnterExecutingModeIterative",
    dynlib: helicsSharedLib.}
## *
##  Request an iterative entry to the execution mode.
##
##  @details This call allows for finer grain control of the iterative process than /ref helicsFederateRequestTime. It takes a time and
##           iteration request, and returns a time and iteration status
##
##  @param fed The federate to make the request of.
##  @param iterate The requested iteration mode.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateEnterExecutingModeIterativeAsync*(fed: helics_federate;
    iterate: helics_iteration_request; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateEnterExecutingModeIterativeAsync",
    dynlib: helicsSharedLib.}
## *
##  Complete the asynchronous iterative call into ExecutionMode.
##
##  @param fed The federate to make the request of.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return An iteration object containing the iteration time and iteration_status.
##

proc helicsFederateEnterExecutingModeIterativeComplete*(fed: helics_federate;
    err: ptr helics_error): helics_iteration_result {.cdecl,
    importc: "helicsFederateEnterExecutingModeIterativeComplete",
    dynlib: helicsSharedLib.}
## *
##  Get the current state of a federate.
##
##  @param fed The federate to query.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return State the resulting state if void return helics_ok.
##

proc helicsFederateGetState*(fed: helics_federate; err: ptr helics_error): helics_federate_state {.
    cdecl, importc: "helicsFederateGetState", dynlib: helicsSharedLib.}
## *
##  Get the core object associated with a federate.
##
##  @param fed A federate object.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A core object, nullptr if invalid.
##

proc helicsFederateGetCoreObject*(fed: helics_federate; err: ptr helics_error): helics_core {.
    cdecl, importc: "helicsFederateGetCoreObject", dynlib: helicsSharedLib.}
## *
##  Request the next time for federate execution.
##
##  @param fed The federate to make the request of.
##  @param requestTime The next requested time.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return The time granted to the federate, will return helics_time_maxtime if the simulation has terminated or is invalid.
##

proc helicsFederateRequestTime*(fed: helics_federate; requestTime: helics_time;
                               err: ptr helics_error): helics_time {.cdecl,
    importc: "helicsFederateRequestTime", dynlib: helicsSharedLib.}
## *
##  Request the next time for federate execution.
##
##  @param fed The federate to make the request of.
##  @param timeDelta The requested amount of time to advance.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return The time granted to the federate, will return helics_time_maxtime if the simulation has terminated or is invalid
##

proc helicsFederateRequestTimeAdvance*(fed: helics_federate;
                                      timeDelta: helics_time;
                                      err: ptr helics_error): helics_time {.cdecl,
    importc: "helicsFederateRequestTimeAdvance", dynlib: helicsSharedLib.}
## *
##  Request the next time step for federate execution.
##
##  @details Feds should have setup the period or minDelta for this to work well but it will request the next time step which is the current
##  time plus the minimum time step.
##
##  @param fed The federate to make the request of.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return The time granted to the federate, will return helics_time_maxtime if the simulation has terminated or is invalid
##

proc helicsFederateRequestNextStep*(fed: helics_federate; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateRequestNextStep", dynlib: helicsSharedLib.}
## *
##  Request an iterative time.
##
##  @details This call allows for finer grain control of the iterative process than /ref helicsFederateRequestTime. It takes a time and and
##  iteration request, and returns a time and iteration status.
##
##  @param fed The federate to make the request of.
##  @param requestTime The next desired time.
##  @param iterate The requested iteration mode.
##  @forcpponly
##  @param[out] outIteration  The iteration specification of the result.
##  @endforcpponly
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return The granted time, will return helics_time_maxtime if the simulation has terminated along with the appropriate iteration result.
##  @beginPythonOnly
##  This function also returns the iteration specification of the result.
##  @endPythonOnly
##

proc helicsFederateRequestTimeIterative*(fed: helics_federate;
                                        requestTime: helics_time;
                                        iterate: helics_iteration_request;
    outIteration: ptr helics_iteration_result; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateRequestTimeIterative", dynlib: helicsSharedLib.}
## *
##  Request the next time for federate execution in an asynchronous call.
##
##  @details Call /ref helicsFederateRequestTimeComplete to finish the call.
##
##  @param fed The federate to make the request of.
##  @param requestTime The next requested time.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateRequestTimeAsync*(fed: helics_federate;
                                    requestTime: helics_time;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsFederateRequestTimeAsync", dynlib: helicsSharedLib.}
## *
##  Complete an asynchronous requestTime call.
##
##  @param fed The federate to make the request of.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return The time granted to the federate, will return helics_time_maxtime if the simulation has terminated.
##

proc helicsFederateRequestTimeComplete*(fed: helics_federate; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateRequestTimeComplete", dynlib: helicsSharedLib.}
## *
##  Request an iterative time through an asynchronous call.
##
##  @details This call allows for finer grain control of the iterative process than /ref helicsFederateRequestTime. It takes a time and
##  iteration request, and returns a time and iteration status. Call /ref helicsFederateRequestTimeIterativeComplete to finish the process.
##
##  @param fed The federate to make the request of.
##  @param requestTime The next desired time.
##  @param iterate The requested iteration mode.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateRequestTimeIterativeAsync*(fed: helics_federate;
    requestTime: helics_time; iterate: helics_iteration_request;
    err: ptr helics_error) {.cdecl,
                          importc: "helicsFederateRequestTimeIterativeAsync",
                          dynlib: helicsSharedLib.}
## *
##  Complete an iterative time request asynchronous call.
##
##  @param fed The federate to make the request of.
##  @forcpponly
##  @param[out] outIterate The iteration specification of the result.
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return The granted time, will return helics_time_maxtime if the simulation has terminated.
##  @beginPythonOnly
##  This function also returns the iteration specification of the result.
##  @endPythonOnly
##

proc helicsFederateRequestTimeIterativeComplete*(fed: helics_federate;
    outIterate: ptr helics_iteration_result; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateRequestTimeIterativeComplete",
    dynlib: helicsSharedLib.}
## *
##  Get the name of the federate.
##
##  @param fed The federate object to query.
##
##  @return A pointer to a string with the name.
##

proc helicsFederateGetName*(fed: helics_federate): cstring {.cdecl,
    importc: "helicsFederateGetName", dynlib: helicsSharedLib.}
## *
##  Set a time based property for a federate.
##
##  @param fed The federate object to set the property for.
##  @param timeProperty A integer code for a time property.
##  @param time The requested value of the property.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateSetTimeProperty*(fed: helics_federate; timeProperty: cint;
                                   time: helics_time; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateSetTimeProperty", dynlib: helicsSharedLib.}
## *
##  Set a flag for the federate.
##
##  @param fed The federate to alter a flag for.
##  @param flag The flag to change.
##  @param flagValue The new value of the flag. 0 for false, !=0 for true.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateSetFlagOption*(fed: helics_federate; flag: cint;
                                 flagValue: helics_bool; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateSetFlagOption", dynlib: helicsSharedLib.}
## *
##  Set the separator character in a federate.
##
##  @details The separator character is the separation character for local publications/endpoints in creating their global name.
##           For example if the separator character is '/' then a local endpoint would have a globally reachable name of fedName/localName.
##
##  @param fed The federate info object to alter.
##  @param separator The character to use as a separator.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateSetSeparator*(fed: helics_federate; separator: char;
                                err: ptr helics_error) {.cdecl,
    importc: "helicsFederateSetSeparator", dynlib: helicsSharedLib.}
## *
##  Set an integer based property of a federate.
##
##  @param fed The federate to change the property for.
##  @param intProperty The property to set.
##  @param propertyVal The value of the property.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateSetIntegerProperty*(fed: helics_federate; intProperty: cint;
                                      propertyVal: cint; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateSetIntegerProperty", dynlib: helicsSharedLib.}
## *
##  Get the current value of a time based property in a federate.
##
##  @param fed The federate query.
##  @param timeProperty The property to query.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsFederateGetTimeProperty*(fed: helics_federate; timeProperty: cint;
                                   err: ptr helics_error): helics_time {.cdecl,
    importc: "helicsFederateGetTimeProperty", dynlib: helicsSharedLib.}
## *
##  Get a flag value for a federate.
##
##  @param fed The federate to get the flag for.
##  @param flag The flag to query.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return The value of the flag.
##

proc helicsFederateGetFlagOption*(fed: helics_federate; flag: cint;
                                 err: ptr helics_error): helics_bool {.cdecl,
    importc: "helicsFederateGetFlagOption", dynlib: helicsSharedLib.}
## *
##  Get the current value of an integer property (such as a logging level).
##
##  @param fed The federate to get the flag for.
##  @param intProperty A code for the property to set /ref helics_handle_options.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return The value of the property.
##

proc helicsFederateGetIntegerProperty*(fed: helics_federate; intProperty: cint;
                                      err: ptr helics_error): cint {.cdecl,
    importc: "helicsFederateGetIntegerProperty", dynlib: helicsSharedLib.}
## *
##  Get the current time of the federate.
##
##  @param fed The federate object to query.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return The current time of the federate.
##

proc helicsFederateGetCurrentTime*(fed: helics_federate; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsFederateGetCurrentTime", dynlib: helicsSharedLib.}
## *
##  Set a federation global value through a federate.
##
##  @details This overwrites any previous value for this name.
##  @param fed The federate to set the global through.
##  @param valueName The name of the global to set.
##  @param value The value of the global.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFederateSetGlobal*(fed: helics_federate; valueName: cstring;
                             value: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsFederateSetGlobal", dynlib: helicsSharedLib.}
## *
##  Add a time dependency for a federate. The federate will depend on the given named federate for time synchronization.
##
##  @param fed The federate to add the dependency for.
##  @param fedName The name of the federate to depend on.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFederateAddDependency*(fed: helics_federate; fedName: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsFederateAddDependency", dynlib: helicsSharedLib.}
## *
##  Set the logging file for a federate (actually on the core associated with a federate).
##
##  @param fed The federate to set the log file for.
##  @param logFile The name of the log file.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFederateSetLogFile*(fed: helics_federate; logFile: cstring;
                              err: ptr helics_error) {.cdecl,
    importc: "helicsFederateSetLogFile", dynlib: helicsSharedLib.}
## *
##  Log an error message through a federate.
##
##  @param fed The federate to log the error message through.
##  @param logmessage The message to put in the log.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFederateLogErrorMessage*(fed: helics_federate; logmessage: cstring;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFederateLogErrorMessage", dynlib: helicsSharedLib.}
## *
##  Log a warning message through a federate.
##
##  @param fed The federate to log the warning message through.
##  @param logmessage The message to put in the log.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFederateLogWarningMessage*(fed: helics_federate; logmessage: cstring;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsFederateLogWarningMessage", dynlib: helicsSharedLib.}
## *
##  Log an info message through a federate.
##
##  @param fed The federate to log the info message through.
##  @param logmessage The message to put in the log.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFederateLogInfoMessage*(fed: helics_federate; logmessage: cstring;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsFederateLogInfoMessage", dynlib: helicsSharedLib.}
## *
##  Log a debug message through a federate.
##
##  @param fed The federate to log the debug message through.
##  @param logmessage The message to put in the log.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFederateLogDebugMessage*(fed: helics_federate; logmessage: cstring;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFederateLogDebugMessage", dynlib: helicsSharedLib.}
## *
##  Log a message through a federate.
##
##  @param fed The federate to log the message through.
##  @param loglevel The level of the message to log see /ref helics_log_levels.
##  @param logmessage The message to put in the log.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFederateLogLevelMessage*(fed: helics_federate; loglevel: cint;
                                   logmessage: cstring; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateLogLevelMessage", dynlib: helicsSharedLib.}
## *
##  Set a global value in a core.
##
##  @details This overwrites any previous value for this name.
##
##  @param core The core to set the global through.
##  @param valueName The name of the global to set.
##  @param value The value of the global.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsCoreSetGlobal*(core: helics_core; valueName: cstring; value: cstring;
                         err: ptr helics_error) {.cdecl,
    importc: "helicsCoreSetGlobal", dynlib: helicsSharedLib.}
## *
##  Set a federation global value.
##
##  @details This overwrites any previous value for this name.
##
##  @param broker The broker to set the global through.
##  @param valueName The name of the global to set.
##  @param value The value of the global.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsBrokerSetGlobal*(broker: helics_broker; valueName: cstring;
                           value: cstring; err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerSetGlobal", dynlib: helicsSharedLib.}
## *
##  Set the log file on a core.
##
##  @param core The core to set the log file for.
##  @param logFileName The name of the file to log to.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsCoreSetLogFile*(core: helics_core; logFileName: cstring;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsCoreSetLogFile", dynlib: helicsSharedLib.}
## *
##  Set the log file on a broker.
##
##  @param broker The broker to set the log file for.
##  @param logFileName The name of the file to log to.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsBrokerSetLogFile*(broker: helics_broker; logFileName: cstring;
                            err: ptr helics_error) {.cdecl,
    importc: "helicsBrokerSetLogFile", dynlib: helicsSharedLib.}
## *
##  Create a query object.
##
##  @details A query object consists of a target and query string.
##
##  @param target The name of the target to query.
##  @param query The query to make of the target.
##

proc helicsCreateQuery*(target: cstring; query: cstring): helics_query {.cdecl,
    importc: "helicsCreateQuery", dynlib: helicsSharedLib.}
## *
##  Execute a query.
##
##  @details The call will block until the query finishes which may require communication or other delays.
##
##  @param query The query object to use in the query.
##  @param fed A federate to send the query through.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A pointer to a string.  The string will remain valid until the query is freed or executed again.
##  @forcpponly
##          The return will be nullptr if fed or query is an invalid object, the return string will be "#invalid" if the query itself was invalid.
##  @endforcpponly
##

proc helicsQueryExecute*(query: helics_query; fed: helics_federate;
                        err: ptr helics_error): cstring {.cdecl,
    importc: "helicsQueryExecute", dynlib: helicsSharedLib.}
## *
##  Execute a query directly on a core.
##
##  @details The call will block until the query finishes which may require communication or other delays.
##
##  @param query The query object to use in the query.
##  @param core The core to send the query to.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A pointer to a string.  The string will remain valid until the query is freed or executed again.
##  @forcpponly
##          The return will be nullptr if core or query is an invalid object, the return string will be "#invalid" if the query itself was invalid.
##  @endforcpponly
##

proc helicsQueryCoreExecute*(query: helics_query; core: helics_core;
                            err: ptr helics_error): cstring {.cdecl,
    importc: "helicsQueryCoreExecute", dynlib: helicsSharedLib.}
## *
##  Execute a query directly on a broker.
##
##  @details The call will block until the query finishes which may require communication or other delays.
##
##  @param query The query object to use in the query.
##  @param broker The broker to send the query to.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A pointer to a string.  The string will remain valid until the query is freed or executed again.
##  @forcpponly
##          The return will be nullptr if broker or query is an invalid object, the return string will be "#invalid" if the query itself was invalid
##  @endforcpponly
##

proc helicsQueryBrokerExecute*(query: helics_query; broker: helics_broker;
                              err: ptr helics_error): cstring {.cdecl,
    importc: "helicsQueryBrokerExecute", dynlib: helicsSharedLib.}
## *
##  Execute a query in a non-blocking call.
##
##  @param query The query object to use in the query.
##  @param fed A federate to send the query through.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsQueryExecuteAsync*(query: helics_query; fed: helics_federate;
                             err: ptr helics_error) {.cdecl,
    importc: "helicsQueryExecuteAsync", dynlib: helicsSharedLib.}
## *
##  Complete the return from a query called with /ref helicsExecuteQueryAsync.
##
##  @details The function will block until the query completes /ref isQueryComplete can be called to determine if a query has completed or not.
##
##  @param query The query object to complete execution of.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @return A pointer to a string. The string will remain valid until the query is freed or executed again.
##  @forcpponly
##          The return will be nullptr if query is an invalid object
##  @endforcpponly
##

proc helicsQueryExecuteComplete*(query: helics_query; err: ptr helics_error): cstring {.
    cdecl, importc: "helicsQueryExecuteComplete", dynlib: helicsSharedLib.}
## *
##  Check if an asynchronously executed query has completed.
##
##  @details This function should usually be called after a QueryExecuteAsync function has been called.
##
##  @param query The query object to check if completed.
##
##  @return Will return helics_true if an asynchronous query has completed or a regular query call was made with a result,
##          and false if an asynchronous query has not completed or is invalid
##

proc helicsQueryIsCompleted*(query: helics_query): helics_bool {.cdecl,
    importc: "helicsQueryIsCompleted", dynlib: helicsSharedLib.}
## *
##  Free the memory associated with a query object.
##

proc helicsQueryFree*(query: helics_query) {.cdecl, importc: "helicsQueryFree",
    dynlib: helicsSharedLib.}
## *
##  Function to do some housekeeping work.
##
##  @details This runs some cleanup routines and tries to close out any residual thread that haven't been shutdown yet.
##

proc helicsCleanupLibrary*() {.cdecl, importc: "helicsCleanupLibrary",
                             dynlib: helicsSharedLib.}
