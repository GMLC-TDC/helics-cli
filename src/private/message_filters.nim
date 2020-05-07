##
## Copyright (c) 2017-2020,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##
## *
##  @file
##
## @brief Functions related to message filters for the C api
##

import
  helics

## *
##  Create a source Filter on the specified federate.
##
##  @details Filters can be created through a federate or a core, linking through a federate allows
##           a few extra features of name matching to function on the federate interface but otherwise equivalent behavior
##
##  @param fed The federate to register through.
##  @param type The type of filter to create /ref helics_filter_type.
##  @param name The name of the filter (can be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_filter object.
##

proc helicsFederateRegisterFilter*(fed: helics_federate;
                                  `type`: helics_filter_type; name: cstring;
                                  err: ptr helics_error): helics_filter {.cdecl,
    importc: "helicsFederateRegisterFilter", dynlib: helicsSharedLib.}
## *
##  Create a global source filter through a federate.
##
##  @details Filters can be created through a federate or a core, linking through a federate allows
##           a few extra features of name matching to function on the federate interface but otherwise equivalent behavior.
##
##  @param fed The federate to register through.
##  @param type The type of filter to create /ref helics_filter_type.
##  @param name The name of the filter (can be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_filter object.
##

proc helicsFederateRegisterGlobalFilter*(fed: helics_federate;
                                        `type`: helics_filter_type; name: cstring;
                                        err: ptr helics_error): helics_filter {.
    cdecl, importc: "helicsFederateRegisterGlobalFilter", dynlib: helicsSharedLib.}
## *
##  Create a cloning Filter on the specified federate.
##
##  @details Cloning filters copy a message and send it to multiple locations, source and destination can be added
##           through other functions.
##
##  @param fed The federate to register through.
##  @param name The name of the filter (can be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_filter object.
##

proc helicsFederateRegisterCloningFilter*(fed: helics_federate; name: cstring;
    err: ptr helics_error): helics_filter {.cdecl, importc: "helicsFederateRegisterCloningFilter",
                                        dynlib: helicsSharedLib.}
## *
##  Create a global cloning Filter on the specified federate.
##
##  @details Cloning filters copy a message and send it to multiple locations, source and destination can be added
##           through other functions.
##
##  @param fed The federate to register through.
##  @param name The name of the filter (can be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_filter object.
##

proc helicsFederateRegisterGlobalCloningFilter*(fed: helics_federate;
    name: cstring; err: ptr helics_error): helics_filter {.cdecl,
    importc: "helicsFederateRegisterGlobalCloningFilter", dynlib: helicsSharedLib.}
## *
##  Create a source Filter on the specified core.
##
##  @details Filters can be created through a federate or a core, linking through a federate allows
##           a few extra features of name matching to function on the federate interface but otherwise equivalent behavior.
##
##  @param core The core to register through.
##  @param type The type of filter to create /ref helics_filter_type.
##  @param name The name of the filter (can be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_filter object.
##

proc helicsCoreRegisterFilter*(core: helics_core; `type`: helics_filter_type;
                              name: cstring; err: ptr helics_error): helics_filter {.
    cdecl, importc: "helicsCoreRegisterFilter", dynlib: helicsSharedLib.}
## *
##  Create a cloning Filter on the specified core.
##
##  @details Cloning filters copy a message and send it to multiple locations, source and destination can be added
##           through other functions.
##
##  @param core The core to register through.
##  @param name The name of the filter (can be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_filter object.
##

proc helicsCoreRegisterCloningFilter*(core: helics_core; name: cstring;
                                     err: ptr helics_error): helics_filter {.cdecl,
    importc: "helicsCoreRegisterCloningFilter", dynlib: helicsSharedLib.}
## *
##  Get the number of filters registered through a federate.
##
##  @param fed The federate object to use to get the filter.
##
##  @return A count of the number of filters registered through a federate.
##

proc helicsFederateGetFilterCount*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederateGetFilterCount", dynlib: helicsSharedLib.}
## *
##  Get a filter by its name, typically already created via registerInterfaces file or something of that nature.
##
##  @param fed The federate object to use to get the filter.
##  @param name The name of the filter.
##  @forcpponly
##  @param[in,out] err The error object to complete if there is an error.
##  @endforcpponly
##
##  @return A helics_filter object, the object will not be valid and err will contain an error code if no filter with the specified name exists.
##

proc helicsFederateGetFilter*(fed: helics_federate; name: cstring;
                             err: ptr helics_error): helics_filter {.cdecl,
    importc: "helicsFederateGetFilter", dynlib: helicsSharedLib.}
## *
##  Get a filter by its index, typically already created via registerInterfaces file or something of that nature.
##
##  @param fed The federate object in which to create a publication.
##  @param index The index of the publication to get.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_filter, which will be NULL if an invalid index is given.
##

proc helicsFederateGetFilterByIndex*(fed: helics_federate; index: cint;
                                    err: ptr helics_error): helics_filter {.cdecl,
    importc: "helicsFederateGetFilterByIndex", dynlib: helicsSharedLib.}
## *
##  Check if a filter is valid.
##
##  @param filt The filter object to check.
##
##  @return helics_true if the Filter object represents a valid filter.
##

proc helicsFilterIsValid*(filt: helics_filter): helics_bool {.cdecl,
    importc: "helicsFilterIsValid", dynlib: helicsSharedLib.}
## *
##  Get the name of the filter and store in the given string.
##
##  @param filt The given filter.
##
##  @return A string with the name of the filter.
##

proc helicsFilterGetName*(filt: helics_filter): cstring {.cdecl,
    importc: "helicsFilterGetName", dynlib: helicsSharedLib.}
## *
##  Set a property on a filter.
##
##  @param filt The filter to modify.
##  @param prop A string containing the property to set.
##  @param val A numerical value for the property.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFilterSet*(filt: helics_filter; prop: cstring; val: cdouble;
                     err: ptr helics_error) {.cdecl, importc: "helicsFilterSet",
    dynlib: helicsSharedLib.}
## *
##  Set a string property on a filter.
##
##  @param filt The filter to modify.
##  @param prop A string containing the property to set.
##  @param val A string containing the new value.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFilterSetString*(filt: helics_filter; prop: cstring; val: cstring;
                           err: ptr helics_error) {.cdecl,
    importc: "helicsFilterSetString", dynlib: helicsSharedLib.}
## *
##  Add a destination target to a filter.
##
##  @details All messages going to a destination are copied to the delivery address(es).
##  @param filt The given filter to add a destination target to.
##  @param dest The name of the endpoint to add as a destination target.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFilterAddDestinationTarget*(filt: helics_filter; dest: cstring;
                                      err: ptr helics_error) {.cdecl,
    importc: "helicsFilterAddDestinationTarget", dynlib: helicsSharedLib.}
## *
##  Add a source target to a filter.
##
##  @details All messages coming from a source are copied to the delivery address(es).
##
##  @param filt The given filter.
##  @param source The name of the endpoint to add as a source target.
##  @forcpponly.
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFilterAddSourceTarget*(filt: helics_filter; source: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsFilterAddSourceTarget", dynlib: helicsSharedLib.}
## *
##  \defgroup Clone filter functions
##  @details Functions that manipulate cloning filters in some way.
##  @{
##
## *
##  Add a delivery endpoint to a cloning filter.
##
##  @details All cloned messages are sent to the delivery address(es).
##
##  @param filt The given filter.
##  @param deliveryEndpoint The name of the endpoint to deliver messages to.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFilterAddDeliveryEndpoint*(filt: helics_filter;
                                     deliveryEndpoint: cstring;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsFilterAddDeliveryEndpoint", dynlib: helicsSharedLib.}
## *
##  Remove a destination target from a filter.
##
##  @param filt The given filter.
##  @param target The named endpoint to remove as a target.
##  @forcpponly
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFilterRemoveTarget*(filt: helics_filter; target: cstring;
                              err: ptr helics_error) {.cdecl,
    importc: "helicsFilterRemoveTarget", dynlib: helicsSharedLib.}
## *
##  Remove a delivery destination from a cloning filter.
##
##  @param filt The given filter (must be a cloning filter).
##  @param deliveryEndpoint A string with the delivery endpoint to remove.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsFilterRemoveDeliveryEndpoint*(filt: helics_filter;
                                        deliveryEndpoint: cstring;
                                        err: ptr helics_error) {.cdecl,
    importc: "helicsFilterRemoveDeliveryEndpoint", dynlib: helicsSharedLib.}
## *
##  Get the data in the info field of a filter.
##
##  @param filt The given filter.
##
##  @return A string with the info field string.
##

proc helicsFilterGetInfo*(filt: helics_filter): cstring {.cdecl,
    importc: "helicsFilterGetInfo", dynlib: helicsSharedLib.}
## *
##  Set the data in the info field for a filter.
##
##  @param filt The given filter.
##  @param info The string to set.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsFilterSetInfo*(filt: helics_filter; info: cstring; err: ptr helics_error) {.
    cdecl, importc: "helicsFilterSetInfo", dynlib: helicsSharedLib.}
## *
##  Set the data in the info field for a filter.
##
##  @param filt The given filter.
##  @param option The option to set /ref helics_handle_options.
##  @param value The value of the option (helics_true or helics_false).
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsFilterSetOption*(filt: helics_filter; option: cint; value: helics_bool;
                           err: ptr helics_error) {.cdecl,
    importc: "helicsFilterSetOption", dynlib: helicsSharedLib.}
## *
##  Get a handle option for the filter.
##
##  @param filt The given filter to query.
##  @param option The option to query /ref helics_handle_options.
##

proc helicsFilterGetOption*(filt: helics_filter; option: cint): helics_bool {.cdecl,
    importc: "helicsFilterGetOption", dynlib: helicsSharedLib.}
## *
##  @}
##
