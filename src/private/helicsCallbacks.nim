##
## Copyright (c) 2017-2020,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##
## * @file
## @brief functions dealing with callbacks for the shared library
##

import
  helics

## * set the logging callback to a broker
##     @details add a logging callback function for the C The logging callback will be called when
##     a message flows into a broker from the core or from a broker
##     @param broker the broker object in which to set the callback
##     @param logger a callback with signature void(int, const char *, const char *, void *);
##     the function arguments are loglevel,  an identifier, and a message string, and a pointer to user data
##     @param userdata a pointer to user data that is passed to the function when executing
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsBrokerSetLoggingCallback*(broker: helics_broker; logger: proc (
    loglevel: cint; identifier: cstring; message: cstring; userData: pointer) {.cdecl.};
                                    userdata: pointer; err: ptr helics_error) {.
    cdecl, importc: "helicsBrokerSetLoggingCallback", header: "helicsCallbacks.h".}
## * set the logging callback for a core
##     @details add a logging callback function for the C The logging callback will be called when
##     a message flows into a core from the core or from a broker
##     @param core the core object in which to set the callback
##     @param logger a callback with signature void(int, const char *, const char *, void *);
##     the function arguments are loglevel,  an identifier, and a message string
##     @param userdata a pointer to user data that is passed to the function when executing
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsCoreSetLoggingCallback*(core: helics_core; logger: proc (loglevel: cint;
    identifier: cstring; message: cstring; userData: pointer) {.cdecl.};
                                  userdata: pointer; err: ptr helics_error) {.cdecl,
    importc: "helicsCoreSetLoggingCallback", header: "helicsCallbacks.h".}
## * set the logging callback for a federate
##        @details add a logging callback function for the C The logging callback will be called when
##        a message flows into a federate from the core or from a federate
##        @param fed the federate object in which to create a subscription must have been create with helicsCreateValueFederate or
##        helicsCreateCombinationFederate
##        @param logger a callback with signature void(int, const char *, const char *, void *);
##         the function arguments are loglevel,  an identifier string, and a message string, and a pointer to user data
##         @param userdata a pointer to user data that is passed to the function when executing
##         @param[in,out] err a pointer to an error object for catching errors
##

proc helicsFederateSetLoggingCallback*(fed: helics_federate; logger: proc (
    loglevel: cint; identifier: cstring; message: cstring; userData: pointer) {.cdecl.};
                                      userdata: pointer; err: ptr helics_error) {.
    cdecl, importc: "helicsFederateSetLoggingCallback", header: "helicsCallbacks.h".}
## * set a general callback for a custom filter
##     @details add a custom filter callback for creating a custom filter operation in the C shared library
##     @param filter the filter object to set the callback for
##     @param filtCall a callback with signature helics_message_object(helics_message_object, void *);
##     the function arguments are message,  the message to filter, and a pointer to user data. The filter should return a new message
##     @param userdata a pointer to user data that is passed to the function when executing
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsFilterSetCustomCallback*(filter: helics_filter; filtCall: proc (
    message: helics_message_object; userData: pointer) {.cdecl.}; userdata: pointer;
                                   err: ptr helics_error) {.cdecl,
    importc: "helicsFilterSetCustomCallback", header: "helicsCallbacks.h".}
