##
## Copyright (c) 2017-2019,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##
## * @file
## @brief functions related the message filters for the C api
##

import
  helics

## * create a source Filter on the specified federate
##     @details filters can be created through a federate or a core , linking through a federate allows
##     a few extra features of name matching to function on the federate interface but otherwise equivalent behavior
##     @param fed the fed to register through
##    @param type the type of filter to create /ref helics_filter_type
##     @param name the name of the filter (can be NULL)
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_filter object
##

proc helicsFederateRegisterFilter*(fed: helics_federate;
                                  `type`: helics_filter_type; name: cstring;
                                  err: ptr helics_error): helics_filter {.cdecl.}
## * create a globl source filter through a federate
##     @details filters can be created through a federate or a core , linking through a federate allows
##     a few extra features of name matching to function on the federate interface but otherwise equivalent behavior
##     @param fed the fed to register through
##     @param type the type of filter to create /ref helics_filter_type
##     @param name the name of the filter (can be NULL)
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_filter object
##

proc helicsFederateRegisterGlobalFilter*(fed: helics_federate;
                                        `type`: helics_filter_type; name: cstring;
                                        err: ptr helics_error): helics_filter {.
    cdecl.}
## * create a cloning Filter on the specified federate
##     @details cloning filters copy a message and send it to multiple locations source and destination can be added
##     through other functions
##     @param fed the fed to register through
##     @param deliveryEndpoint the specified endpoint to deliver the message
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_filter object
##

proc helicsFederateRegisterCloningFilter*(fed: helics_federate;
    deliveryEndpoint: cstring; err: ptr helics_error): helics_filter {.cdecl.}
## * create a global cloning Filter on the specified federate
##     @details cloning filters copy a message and send it to multiple locations source and destination can be added
##     through other functions
##     @param fed the fed to register through
##     @param deliveryEndpoint the specified endpoint to deliver the message
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_filter object
##

proc helicsFederateRegisterGlobalCloningFilter*(fed: helics_federate;
    deliveryEndpoint: cstring; err: ptr helics_error): helics_filter {.cdecl.}
## * create a source Filter on the specified core
##     @details filters can be created through a federate or a core , linking through a federate allows
##     a few extra features of name matching to function on the federate interface but otherwise equivalent behavior
##     @param core the core to register through
##     @param type the type of filter to create /ref helics_filter_type
##     @param name the name of the filter (can be NULL)
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_filter object
##

proc helicsCoreRegisterFilter*(core: helics_core; `type`: helics_filter_type;
                              name: cstring; err: ptr helics_error): helics_filter {.
    cdecl.}
## * create a cloning Filter on the specified core
##     @details cloning filters copy a message and send it to multiple locations source and destination can be added
##     through other functions
##     @param core the core to register through
##     @param deliveryEndpoint the specified endpoint to deliver the message
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_filter object
##

proc helicsCoreRegisterCloningFilter*(core: helics_core; deliveryEndpoint: cstring;
                                     err: ptr helics_error): helics_filter {.cdecl.}
## * get a the number of filters registered through a federate
##     @param fed the federate object to use to get the filter
##     @return a count of the number of filters registered through a federate
##

proc helicsFederateGetFilterCount*(fed: helics_federate): cint {.cdecl.}
## * get a filter by its name typically already created via registerInterfaces file or something of that nature
##     @param fed the federate object to use to get the filter
##     @param name the name of the filter
##     @param[in,out] err the error object to complete if there is an error
##     @return a helics_filter object, the object will not be valid and err will contain an error code if no filter with the specified
##     name exists
##

proc helicsFederateGetFilter*(fed: helics_federate; name: cstring;
                             err: ptr helics_error): helics_filter {.cdecl.}
## * get a filter by its index typically already created via registerInterfaces file or something of that nature
##     @param fed the federate object in which to create a publication
##     @param index the index of the publication to get
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_filter, which will be NULL if an invalid index
##

proc helicsFederateGetFilterByIndex*(fed: helics_federate; index: cint;
                                    err: ptr helics_error): helics_filter {.cdecl.}
## * get the name of the filter and store in the given string
##     @param filt the given filter
##     @return a string with the name of the filter

proc helicsFilterGetName*(filt: helics_filter): cstring {.cdecl.}
## * set a property on a filter
##     @param filt the filter to modify
##     @param prop a string containing the property to set
##     @param val a numerical value of the property
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsFilterSet*(filt: helics_filter; prop: cstring; val: cdouble;
                     err: ptr helics_error) {.cdecl.}
## * set a string property on a filter
##     @param filt the filter to modify
##     @param prop a string containing the property to set
##     @param val a string containing the new value
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsFilterSetString*(filt: helics_filter; prop: cstring; val: cstring;
                           err: ptr helics_error) {.cdecl.}
## * add a destination target to a filter
##     @details all messages going to a destination are copied to the delivery address(es)
##     @param filt the given filter to add a destination target
##     @param dest the name of the endpoint to add as a destination target
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsFilterAddDestinationTarget*(filt: helics_filter; dest: cstring;
                                      err: ptr helics_error) {.cdecl.}
## * add a source target to a filter
##     @details all messages coming from a source are copied to the delivery address(es)
##     @param filt the given filter
##     @param source the name of the endpoint to add as a source target
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsFilterAddSourceTarget*(filt: helics_filter; source: cstring;
                                 err: ptr helics_error) {.cdecl.}
## *
##  \defgroup clone filter functions
##     @details functions that manipulate cloning filters in some way
##  @{
##
## * add a delivery endpoint to a cloning filter
##     @details all cloned messages are sent to the delivery address(es)
##     @param filt the given filter
##     @param deliveryEndpoint the name of the endpoint to deliver messages to
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsFilterAddDeliveryEndpoint*(filt: helics_filter;
                                     deliveryEndpoint: cstring;
                                     err: ptr helics_error) {.cdecl.}
## * remove a destination target from a filter
##     @param filt the given filter
##     @param target the named endpoint to remove as a target
##     @param[in,out] err a pointer to an error object for catching errors

proc helicsFilterRemoveTarget*(filt: helics_filter; target: cstring;
                              err: ptr helics_error) {.cdecl.}
## * remove a delivery destination from a cloning filter
##     @param filt the given filter (must be a cloning filter)
##     @param deliveryEndpoint a string with the deliverEndpoint to remove
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsFilterRemoveDeliveryEndpoint*(filt: helics_filter;
                                        deliveryEndpoint: cstring;
                                        err: ptr helics_error) {.cdecl.}
## * get the data in the info field of an filter
##     @param filt the given filter
##     @return a string with the info field string

proc helicsFilterGetInfo*(filt: helics_filter): cstring {.cdecl.}
## * set the data in the info field for an filter
##     @param filt the given filter
##     @param info the string to set
##     @param[in,out] err an error object to fill out in case of an error

proc helicsFilterSetInfo*(filt: helics_filter; info: cstring; err: ptr helics_error) {.
    cdecl.}
## * set the data in the info field for an filter
##     @param filt the given filter
##     @param option the option to set /ref helics_handle_options
##     @param value the value of the option (helics_true or helics_false)
##     @param[in,out] err an error object to fill out in case of an error

proc helicsFilterSetOption*(filt: helics_filter; option: cint; value: helics_bool;
                           err: ptr helics_error) {.cdecl.}
## * get a handle option for the filter
##     @param filt the given filter to query
##     @param option the option to query /ref helics_handle_options

proc helicsFilterGetOption*(filt: helics_filter; option: cint): helics_bool {.cdecl.}
## *@}
