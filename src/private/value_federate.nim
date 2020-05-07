##
## Copyright (c) 2017-2020,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##
## *
##  @file
##
##  @brief Functions related to value federates for the C api
##

import
  helics

## *
##  sub/pub registration
##
## *
##  Create a subscription.
##
##  @details The subscription becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions and publications.
##
##  @param fed The federate object in which to create a subscription, must have been created with /ref helicsCreateValueFederate or
##  /ref helicsCreateCombinationFederate.
##  @param key The identifier matching a publication to get a subscription for.
##  @param units A string listing the units of the subscription (may be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the subscription.
##

proc helicsFederateRegisterSubscription*(fed: helics_federate; key: cstring;
                                        units: cstring; err: ptr helics_error): helics_input {.
    cdecl, importc: "helicsFederateRegisterSubscription", dynlib: helicsSharedLib.}
## *
##  Register a publication with a known type.
##
##  @details The publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions and publications.
##
##  @param fed The federate object in which to create a publication.
##  @param key The identifier for the publication the global publication key will be prepended with the federate name.
##  @param type A code identifying the type of the input see /ref helics_data_type for available options.
##  @param units A string listing the units of the subscription (may be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the publication.
##

proc helicsFederateRegisterPublication*(fed: helics_federate; key: cstring;
                                       `type`: helics_data_type; units: cstring;
                                       err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateRegisterPublication", dynlib: helicsSharedLib.}
## *
##  Register a publication with a defined type.
##
##  @details The publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions and publications.
##
##  @param fed The federate object in which to create a publication.
##  @param key The identifier for the publication.
##  @param type A string labeling the type of the publication.
##  @param units A string listing the units of the subscription (may be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the publication.
##

proc helicsFederateRegisterTypePublication*(fed: helics_federate; key: cstring;
    `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.cdecl,
    importc: "helicsFederateRegisterTypePublication", dynlib: helicsSharedLib.}
## *
##  Register a global named publication with an arbitrary type.
##
##  @details The publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions and publications.
##
##  @param fed The federate object in which to create a publication.
##  @param key The identifier for the publication.
##  @param type A code identifying the type of the input see /ref helics_data_type for available options.
##  @param units A string listing the units of the subscription (may be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the publication.
##

proc helicsFederateRegisterGlobalPublication*(fed: helics_federate; key: cstring;
    `type`: helics_data_type; units: cstring; err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateRegisterGlobalPublication",
    dynlib: helicsSharedLib.}
## *
##  Register a global publication with a defined type.
##
##  @details The publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions and publications.
##
##  @param fed The federate object in which to create a publication.
##  @param key The identifier for the publication.
##  @param type A string describing the expected type of the publication.
##  @param units A string listing the units of the subscription (may be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the publication.
##

proc helicsFederateRegisterGlobalTypePublication*(fed: helics_federate;
    key: cstring; `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateRegisterGlobalTypePublication",
    dynlib: helicsSharedLib.}
## *
##  Register a named input.
##
##  @details The input becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions, inputs, and publications.
##
##  @param fed The federate object in which to create an input.
##  @param key The identifier for the publication the global input key will be prepended with the federate name.
##  @param type A code identifying the type of the input see /ref helics_data_type for available options.
##  @param units A string listing the units of the input (may be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the input.
##

proc helicsFederateRegisterInput*(fed: helics_federate; key: cstring;
                                 `type`: helics_data_type; units: cstring;
                                 err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateRegisterInput", dynlib: helicsSharedLib.}
## *
##  Register an input with a defined type.
##
##  @details The input becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions, inputs, and publications.
##
##  @param fed The federate object in which to create an input.
##  @param key The identifier for the input.
##  @param type A string describing the expected type of the input.
##  @param units A string listing the units of the input maybe NULL.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the publication.
##

proc helicsFederateRegisterTypeInput*(fed: helics_federate; key: cstring;
                                     `type`: cstring; units: cstring;
                                     err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateRegisterTypeInput", dynlib: helicsSharedLib.}
## *
##  Register a global named input.
##
##  @details The publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions and publications.
##
##  @param fed The federate object in which to create a publication.
##  @param key The identifier for the publication.
##  @param type A code identifying the type of the input see /ref helics_data_type for available options.
##  @param units A string listing the units of the subscription maybe NULL.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the publication.
##

proc helicsFederateRegisterGlobalInput*(fed: helics_federate; key: cstring;
                                       `type`: helics_data_type; units: cstring;
                                       err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateRegisterGlobalInput", dynlib: helicsSharedLib.}
## *
##  Register a global publication with an arbitrary type.
##
##  @details The publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##  functions for subscriptions and publications.
##
##  @param fed The federate object in which to create a publication.
##  @param key The identifier for the publication.
##  @param type A string defining the type of the input.
##  @param units A string listing the units of the subscription maybe NULL.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the publication.
##

proc helicsFederateRegisterGlobalTypeInput*(fed: helics_federate; key: cstring;
    `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.cdecl,
    importc: "helicsFederateRegisterGlobalTypeInput", dynlib: helicsSharedLib.}
## *
##  Get a publication object from a key.
##
##  @param fed The value federate object to use to get the publication.
##  @param key The name of the publication.
##  @forcpponly
##  @param[in,out] err The error object to complete if there is an error.
##  @endforcpponly
##
##  @return A helics_publication object, the object will not be valid and err will contain an error code if no publication with the
##  specified key exists.
##

proc helicsFederateGetPublication*(fed: helics_federate; key: cstring;
                                  err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateGetPublication", dynlib: helicsSharedLib.}
## *
##  Get a publication by its index, typically already created via registerInterfaces file or something of that nature.
##
##  @param fed The federate object in which to create a publication.
##  @param index The index of the publication to get.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_publication.
##

proc helicsFederateGetPublicationByIndex*(fed: helics_federate; index: cint;
    err: ptr helics_error): helics_publication {.cdecl,
    importc: "helicsFederateGetPublicationByIndex", dynlib: helicsSharedLib.}
## *
##  Get an input object from a key.
##
##  @param fed The value federate object to use to get the publication.
##  @param key The name of the input.
##  @forcpponly
##  @param[in,out] err The error object to complete if there is an error.
##  @endforcpponly
##
##  @return A helics_input object, the object will not be valid and err will contain an error code if no input with the specified
##  key exists.
##

proc helicsFederateGetInput*(fed: helics_federate; key: cstring;
                            err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateGetInput", dynlib: helicsSharedLib.}
## *
##  Get an input by its index, typically already created via registerInterfaces file or something of that nature.
##
##  @param fed The federate object in which to create a publication.
##  @param index The index of the publication to get.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_input, which will be NULL if an invalid index.
##

proc helicsFederateGetInputByIndex*(fed: helics_federate; index: cint;
                                   err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateGetInputByIndex", dynlib: helicsSharedLib.}
## *
##  Get an input object from a subscription target.
##
##  @param fed The value federate object to use to get the publication.
##  @param key The name of the publication that a subscription is targeting.
##  @forcpponly
##  @param[in,out] err The error object to complete if there is an error.
##  @endforcpponly
##
##  @return A helics_input object, the object will not be valid and err will contain an error code if no input with the specified
##  key exists.
##

proc helicsFederateGetSubscription*(fed: helics_federate; key: cstring;
                                   err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateGetSubscription", dynlib: helicsSharedLib.}
## *
##  Clear all the update flags from a federates inputs.
##
##

proc helicsFederateClearUpdates*(fed: helics_federate) {.cdecl,
    importc: "helicsFederateClearUpdates", dynlib: helicsSharedLib.}
## *
##  Register the publications via JSON publication string.
##
##  @details This would be the same JSON that would be used to publish data.
##

proc helicsFederateRegisterFromPublicationJSON*(fed: helics_federate;
    json: cstring; err: ptr helics_error) {.cdecl, importc: "helicsFederateRegisterFromPublicationJSON",
                                       dynlib: helicsSharedLib.}
## *
##  Publish data contained in a json file or string.
##

proc helicsFederatePublishJSON*(fed: helics_federate; json: cstring;
                               err: ptr helics_error) {.cdecl,
    importc: "helicsFederatePublishJSON", dynlib: helicsSharedLib.}
## *
##  \defgroup publications Publication functions
##  @details Functions for publishing data of various kinds.
##  The data will get translated to the type specified when the publication was constructed automatically
##  regardless of the function used to publish the data.
##  @{
##
## *
##  Check if a publication is valid.
##
##  @param pub The publication to check.
##
##  @return helics_true if the publication is a valid publication.
##

proc helicsPublicationIsValid*(pub: helics_publication): helics_bool {.cdecl,
    importc: "helicsPublicationIsValid", dynlib: helicsSharedLib.}
## *
##  Publish raw data from a char * and length.
##
##  @param pub The publication to publish for.
##  @param data A pointer to the raw data.
##  @param inputDataLength The size in bytes of the data to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishRaw*(pub: helics_publication; data: pointer;
                                 inputDataLength: cint; err: ptr helics_error) {.
    cdecl, importc: "helicsPublicationPublishRaw", dynlib: helicsSharedLib.}
## *
##  Publish a string.
##
##  @param pub The publication to publish for.
##  @param str The string to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishString*(pub: helics_publication; str: cstring;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishString", dynlib: helicsSharedLib.}
## *
##  Publish an integer value.
##
##  @param pub The publication to publish for.
##  @param val The numerical value to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishInteger*(pub: helics_publication; val: int64_t;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishInteger", dynlib: helicsSharedLib.}
## *
##  Publish a Boolean Value.
##
##  @param pub The publication to publish for.
##  @param val The boolean value to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishBoolean*(pub: helics_publication; val: helics_bool;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishBoolean", dynlib: helicsSharedLib.}
## *
##  Publish a double floating point value.
##
##  @param pub The publication to publish for.
##  @param val The numerical value to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishDouble*(pub: helics_publication; val: cdouble;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishDouble", dynlib: helicsSharedLib.}
## *
##  Publish a time value.
##
##  @param pub The publication to publish for.
##  @param val The numerical value to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishTime*(pub: helics_publication; val: helics_time;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishTime", dynlib: helicsSharedLib.}
## *
##  Publish a single character.
##
##  @param pub The publication to publish for.
##  @param val The numerical value to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishChar*(pub: helics_publication; val: char;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishChar", dynlib: helicsSharedLib.}
## *
##  Publish a complex value (or pair of values).
##
##  @param pub The publication to publish for.
##  @param real The real part of a complex number to publish.
##  @param imag The imaginary part of a complex number to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishComplex*(pub: helics_publication; real: cdouble;
                                     imag: cdouble; err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishComplex", dynlib: helicsSharedLib.}
## *
##  Publish a vector of doubles.
##
##  @param pub The publication to publish for.
##  @param vectorInput A pointer to an array of double data.
##  @forcpponly
##  @param vectorLength The number of points to publish.
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishVector*(pub: helics_publication;
                                    vectorInput: ptr cdouble; vectorLength: cint;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishVector", dynlib: helicsSharedLib.}
## *
##  Publish a named point.
##
##  @param pub The publication to publish for.
##  @param str A string for the name to publish.
##  @param val A double for the value to publish.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationPublishNamedPoint*(pub: helics_publication; str: cstring;
                                        val: cdouble; err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishNamedPoint", dynlib: helicsSharedLib.}
## *
##  Add a named input to the list of targets a publication publishes to.
##
##  @param pub The publication to add the target for.
##  @param target The name of an input that the data should be sent to.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsPublicationAddTarget*(pub: helics_publication; target: cstring;
                                err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationAddTarget", dynlib: helicsSharedLib.}
## *
##  Check if an input is valid.
##
##  @param ipt The input to check.
##
##  @return helics_true if the Input object represents a valid input.
##

proc helicsInputIsValid*(ipt: helics_input): helics_bool {.cdecl,
    importc: "helicsInputIsValid", dynlib: helicsSharedLib.}
## *
##  Add a publication to the list of data that an input subscribes to.
##
##  @param ipt The named input to modify.
##  @param target The name of a publication that an input should subscribe to.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsInputAddTarget*(ipt: helics_input; target: cstring; err: ptr helics_error) {.
    cdecl, importc: "helicsInputAddTarget", dynlib: helicsSharedLib.}
## *@}
## *
##  \defgroup getValue GetValue functions
##  @details Data can be returned in a number of formats,  for instance if data is published as a double it can be returned as a string and
##  vice versa,  not all translations make that much sense but they do work.
##  @{
##
## *
##  Get the size of the raw value for subscription.
##
##  @return The size of the raw data/string in bytes.
##

proc helicsInputGetRawValueSize*(ipt: helics_input): cint {.cdecl,
    importc: "helicsInputGetRawValueSize", dynlib: helicsSharedLib.}
## *
##  Get the raw data for the latest value of a subscription.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[out] data The memory location of the data
##  @param maxDatalen The maximum size of information that data can hold.
##  @param[out] actualSize The actual length of data copied to data.
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @beginPythonOnly
##  @return Raw string data.
##  @endPythonOnly
##

proc helicsInputGetRawValue*(ipt: helics_input; data: pointer; maxDatalen: cint;
                            actualSize: ptr cint; err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetRawValue", dynlib: helicsSharedLib.}
## *
##  Get the size of a value for subscription assuming return as a string.
##
##  @return The size of the string.
##

proc helicsInputGetStringSize*(ipt: helics_input): cint {.cdecl,
    importc: "helicsInputGetStringSize", dynlib: helicsSharedLib.}
## *
##  Get a string value from a subscription.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[out] outputString Storage for copying a null terminated string.
##  @param maxStringLen The maximum size of information that str can hold.
##  @param[out] actualLength The actual length of the string.
##  @param[in,out] err Error term for capturing errors.
##  @endforcpponly
##
##  @beginPythonOnly
##  @return A string data
##  @endPythonOnly
##

proc helicsInputGetString*(ipt: helics_input; outputString: cstring;
                          maxStringLen: cint; actualLength: ptr cint;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetString", dynlib: helicsSharedLib.}
## *
##  Get an integer value from a subscription.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An int64_t value with the current value of the input.
##

proc helicsInputGetInteger*(ipt: helics_input; err: ptr helics_error): int64_t {.cdecl,
    importc: "helicsInputGetInteger", dynlib: helicsSharedLib.}
## *
##  Get a boolean value from a subscription.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A boolean value of current input value.
##

proc helicsInputGetBoolean*(ipt: helics_input; err: ptr helics_error): helics_bool {.
    cdecl, importc: "helicsInputGetBoolean", dynlib: helicsSharedLib.}
## *
##  Get a double value from a subscription.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return The double value of the input.
##

proc helicsInputGetDouble*(ipt: helics_input; err: ptr helics_error): cdouble {.cdecl,
    importc: "helicsInputGetDouble", dynlib: helicsSharedLib.}
## *
##  Get a time value from a subscription.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return The resulting time value.
##

proc helicsInputGetTime*(ipt: helics_input; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsInputGetTime", dynlib: helicsSharedLib.}
## *
##  Get a single character value from an input.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return The resulting character value.
##  @forcpponly
##          NAK (negative acknowledgment) symbol returned on error
##  @endforcpponly
##

proc helicsInputGetChar*(ipt: helics_input; err: ptr helics_error): char {.cdecl,
    importc: "helicsInputGetChar", dynlib: helicsSharedLib.}
## *
##  Get a complex object from an input object.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[in,out] err A helics error object, if the object is not empty the function is bypassed otherwise it is filled in if there is an error.
##  @endforcpponly
##
##  @return A helics_complex structure with the value.
##

proc helicsInputGetComplexObject*(ipt: helics_input; err: ptr helics_error): helics_complex {.
    cdecl, importc: "helicsInputGetComplexObject", dynlib: helicsSharedLib.}
## *
##  Get a pair of double forming a complex number from a subscriptions.
##
##  @param ipt The input to get the data for.
##  @forcpponly
##  @param[out] real Memory location to place the real part of a value.
##  @param[out] imag Memory location to place the imaginary part of a value.
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  On error the values will not be altered.
##  @endforcpponly
##
##  @beginPythonOnly
##  @return a pair of floating point values that represent the real and imag values
##  @endPythonOnly
##

proc helicsInputGetComplex*(ipt: helics_input; real: ptr cdouble; imag: ptr cdouble;
                           err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetComplex", dynlib: helicsSharedLib.}
## *
##  Get the size of a value for subscription assuming return as an array of doubles.
##
##  @return The number of doubles in a returned vector.
##

proc helicsInputGetVectorSize*(ipt: helics_input): cint {.cdecl,
    importc: "helicsInputGetVectorSize", dynlib: helicsSharedLib.}
## *
##  Get a vector from a subscription.
##
##  @param ipt The input to get the result for.
##  @forcpponly
##  @param[out] data The location to store the data.
##  @param maxlen The maximum size of the vector.
##  @param[out] actualSize Location to place the actual length of the resulting vector.
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @beginPythonOnly
##  @return a list of floating point values
##  @endPythonOnly
##

proc helicsInputGetVector*(ipt: helics_input; data: ptr cdouble; maxlen: cint;
                          actualSize: ptr cint; err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetVector", dynlib: helicsSharedLib.}
## *
##  Get a named point from a subscription.
##
##  @param ipt The input to get the result for.
##  @forcpponly
##  @param[out] outputString Storage for copying a null terminated string.
##  @param maxStringLen The maximum size of information that str can hold.
##  @param[out] actualLength The actual length of the string
##  @param[out] val The double value for the named point.
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##
##  @beginPythonOnly
##  @return a string and a double value for the named point
##  @endPythonOnly
##

proc helicsInputGetNamedPoint*(ipt: helics_input; outputString: cstring;
                              maxStringLen: cint; actualLength: ptr cint;
                              val: ptr cdouble; err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetNamedPoint", dynlib: helicsSharedLib.}
## *@}
## *
##  \defgroup default_values Default Value functions
##  @details These functions set the default value for a subscription. That is the value returned if nothing was published from elsewhere.
##  @{
##
## *
##  Set the default as a raw data array.
##
##  @param ipt The input to set the default for.
##  @param data A pointer to the raw data to use for the default.
##  @forcpponly
##  @param inputDataLength The size of the raw data.
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultRaw*(ipt: helics_input; data: pointer;
                              inputDataLength: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultRaw", dynlib: helicsSharedLib.}
## *
##  Set the default as a string.
##
##  @param ipt The input to set the default for.
##  @param str A pointer to the default string.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultString*(ipt: helics_input; str: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultString", dynlib: helicsSharedLib.}
## *
##  Set the default as an integer.
##
##  @param ipt The input to set the default for.
##  @param val The default integer.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultInteger*(ipt: helics_input; val: int64_t;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultInteger", dynlib: helicsSharedLib.}
## *
##  Set the default as a boolean.
##
##  @param ipt The input to set the default for.
##  @param val The default boolean value.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultBoolean*(ipt: helics_input; val: helics_bool;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultBoolean", dynlib: helicsSharedLib.}
## *
##  Set the default as a time.
##
##  @param ipt The input to set the default for.
##  @param val The default time value.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultTime*(ipt: helics_input; val: helics_time;
                               err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultTime", dynlib: helicsSharedLib.}
## *
##  Set the default as a char.
##
##  @param ipt The input to set the default for.
##  @param val The default char value.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultChar*(ipt: helics_input; val: char; err: ptr helics_error) {.
    cdecl, importc: "helicsInputSetDefaultChar", dynlib: helicsSharedLib.}
## *
##  Set the default as a double.
##
##  @param ipt The input to set the default for.
##  @param val The default double value.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultDouble*(ipt: helics_input; val: cdouble;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultDouble", dynlib: helicsSharedLib.}
## *
##  Set the default as a complex number.
##
##  @param ipt The input to set the default for.
##  @param real The default real value.
##  @param imag The default imaginary value.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultComplex*(ipt: helics_input; real: cdouble; imag: cdouble;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultComplex", dynlib: helicsSharedLib.}
## *
##  Set the default as a vector of doubles.
##
##  @param ipt The input to set the default for.
##  @param vectorInput A pointer to an array of double data.
##  @param vectorLength The number of points to publish.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultVector*(ipt: helics_input; vectorInput: ptr cdouble;
                                 vectorLength: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultVector", dynlib: helicsSharedLib.}
## *
##  Set the default as a NamedPoint.
##
##  @param ipt The input to set the default for.
##  @param str A pointer to a string representing the name.
##  @param val A double value for the value of the named point.
##  @forcpponly
##  @param[in,out] err An error object that will contain an error code and string if any error occurred during the execution of the function.
##  @endforcpponly
##

proc helicsInputSetDefaultNamedPoint*(ipt: helics_input; str: cstring; val: cdouble;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultNamedPoint", dynlib: helicsSharedLib.}
## *@}
## *
##  \defgroup Information retrieval
##  @{
##
## *
##  Get the type of an input.
##
##  @param ipt The input to query.
##
##  @return A void enumeration, helics_ok if everything worked.
##

proc helicsInputGetType*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetType", dynlib: helicsSharedLib.}
## *
##  Get the type the publisher to an input is sending.
##
##  @param ipt The input to query.
##
##  @return A const char * with the type name.
##

proc helicsInputGetPublicationType*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetPublicationType", dynlib: helicsSharedLib.}
## *
##  Get the type of a publication.
##
##  @param pub The publication to query.
##
##  @return A void enumeration, helics_ok if everything worked.
##

proc helicsPublicationGetType*(pub: helics_publication): cstring {.cdecl,
    importc: "helicsPublicationGetType", dynlib: helicsSharedLib.}
## *
##  Get the key of an input.
##
##  @param ipt The input to query.
##
##  @return A void enumeration, helics_ok if everything worked.
##

proc helicsInputGetKey*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetKey", dynlib: helicsSharedLib.}
## *
##  Get the key of a subscription.
##
##  @return A const char with the subscription key.
##

proc helicsSubscriptionGetKey*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsSubscriptionGetKey", dynlib: helicsSharedLib.}
## *
##  Get the key of a publication.
##
##  @details This will be the global key used to identify the publication to the federation.
##
##  @param pub The publication to query.
##
##  @return A void enumeration, helics_ok if everything worked.
##

proc helicsPublicationGetKey*(pub: helics_publication): cstring {.cdecl,
    importc: "helicsPublicationGetKey", dynlib: helicsSharedLib.}
## *
##  Get the units of an input.
##
##  @param ipt The input to query.
##
##  @return A void enumeration, helics_ok if everything worked.
##

proc helicsInputGetUnits*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetUnits", dynlib: helicsSharedLib.}
## *
##  Get the units of the publication that an input is linked to.
##
##  @param ipt The input to query.
##
##  @return A void enumeration, helics_ok if everything worked.
##

proc helicsInputGetInjectionUnits*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetInjectionUnits", dynlib: helicsSharedLib.}
## *
##  Get the units of an input.
##
##  @details The same as helicsInputGetUnits.
##
##  @param ipt The input to query.
##
##  @return A void enumeration, helics_ok if everything worked.
##

proc helicsInputGetExtractionUnits*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetExtractionUnits", dynlib: helicsSharedLib.}
## *
##  Get the units of a publication.
##
##  @param pub The publication to query.
##
##  @return A void enumeration, helics_ok if everything worked.
##

proc helicsPublicationGetUnits*(pub: helics_publication): cstring {.cdecl,
    importc: "helicsPublicationGetUnits", dynlib: helicsSharedLib.}
## *
##  Get the data in the info field of an input.
##
##  @param inp The input to query.
##
##  @return A string with the info field string.
##

proc helicsInputGetInfo*(inp: helics_input): cstring {.cdecl,
    importc: "helicsInputGetInfo", dynlib: helicsSharedLib.}
## *
##  Set the data in the info field for an input.
##
##  @param inp The input to query.
##  @param info The string to set.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsInputSetInfo*(inp: helics_input; info: cstring; err: ptr helics_error) {.
    cdecl, importc: "helicsInputSetInfo", dynlib: helicsSharedLib.}
## *
##  Get the data in the info field of an publication.
##
##  @param pub The publication to query.
##
##  @return A string with the info field string.
##

proc helicsPublicationGetInfo*(pub: helics_publication): cstring {.cdecl,
    importc: "helicsPublicationGetInfo", dynlib: helicsSharedLib.}
## *
##  Set the data in the info field for a publication.
##
##  @param pub The publication to set the info field for.
##  @param info The string to set.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsPublicationSetInfo*(pub: helics_publication; info: cstring;
                              err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationSetInfo", dynlib: helicsSharedLib.}
## *
##  Get the data in the info field of an input.
##
##  @param inp The input to query.
##  @param option Integer representation of the option in question see /ref helics_handle_options.
##
##  @return A string with the info field string.
##

proc helicsInputGetOption*(inp: helics_input; option: cint): helics_bool {.cdecl,
    importc: "helicsInputGetOption", dynlib: helicsSharedLib.}
## *
##  Set the data in the info field for an input.
##
##  @param inp The input to query.
##  @param option The option to set for the input /ref helics_handle_options.
##  @param value The value to set the option to.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsInputSetOption*(inp: helics_input; option: cint; value: helics_bool;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetOption", dynlib: helicsSharedLib.}
## *
##  Get the data in the info field of a publication.
##
##  @param pub The publication to query.
##  @param option The value to query see /ref helics_handle_options.
##
##  @return A string with the info field string.
##

proc helicsPublicationGetOption*(pub: helics_publication; option: cint): helics_bool {.
    cdecl, importc: "helicsPublicationGetOption", dynlib: helicsSharedLib.}
## *
##  Set the data in the info field for a publication.
##
##  @param pub The publication to query.
##  @param option Integer code for the option to set /ref helics_handle_options.
##  @param val The value to set the option to.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsPublicationSetOption*(pub: helics_publication; option: cint;
                                val: helics_bool; err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationSetOption", dynlib: helicsSharedLib.}
## *
##  Set the minimum change detection tolerance.
##
##  @param pub The publication to modify.
##  @param tolerance The tolerance level for publication, values changing less than this value will not be published.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsPublicationSetMinimumChange*(pub: helics_publication;
                                       tolerance: cdouble; err: ptr helics_error) {.
    cdecl, importc: "helicsPublicationSetMinimumChange", dynlib: helicsSharedLib.}
## *
##  Set the minimum change detection tolerance.
##
##  @param inp The input to modify.
##  @param tolerance The tolerance level for registering an update, values changing less than this value will not show as being updated.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsInputSetMinimumChange*(inp: helics_input; tolerance: cdouble;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetMinimumChange", dynlib: helicsSharedLib.}
## *@}
## *
##  Check if a particular subscription was updated.
##
##  @return helics_true if it has been updated since the last value retrieval.
##

proc helicsInputIsUpdated*(ipt: helics_input): helics_bool {.cdecl,
    importc: "helicsInputIsUpdated", dynlib: helicsSharedLib.}
## *
##  Get the last time a subscription was updated.
##

proc helicsInputLastUpdateTime*(ipt: helics_input): helics_time {.cdecl,
    importc: "helicsInputLastUpdateTime", dynlib: helicsSharedLib.}
## *
##  Clear the updated flag from an input.
##

proc helicsInputClearUpdate*(ipt: helics_input) {.cdecl,
    importc: "helicsInputClearUpdate", dynlib: helicsSharedLib.}
## *
##  Get the number of publications in a federate.
##
##  @return (-1) if fed was not a valid federate otherwise returns the number of publications.
##

proc helicsFederateGetPublicationCount*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederateGetPublicationCount", dynlib: helicsSharedLib.}
## *
##  Get the number of subscriptions in a federate.
##
##  @return (-1) if fed was not a valid federate otherwise returns the number of subscriptions.
##

proc helicsFederateGetInputCount*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederateGetInputCount", dynlib: helicsSharedLib.}
