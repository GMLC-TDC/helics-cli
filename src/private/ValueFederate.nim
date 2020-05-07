##
## Copyright (c) 2017-2020,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##
## * @file
## @brief The C-API function for valueFederates
##

import
  helics

##  sub/pub registration
## * create a subscription
##     @details the subscription becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a subscription must have been create with helicsCreateValueFederate or
##     helicsCreateCombinationFederate
##     @param key the identifier matching a publication to get a subscription for
##     @param units a string listing the units of the subscription maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the subscription
##

proc helicsFederateRegisterSubscription*(fed: helics_federate; key: cstring;
                                        units: cstring; err: ptr helics_error): helics_input {.
    cdecl, importc: "helicsFederateRegisterSubscription", header: "ValueFederate.h".}
## * register a publication with a a known type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication the global publication key will be prepended with the federate name
##     @param type a code identifying the type of the input see /ref helics_data_type for available options
##     @param units a string listing the units of the subscription maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the publication
##

proc helicsFederateRegisterPublication*(fed: helics_federate; key: cstring;
                                       `type`: helics_data_type; units: cstring;
                                       err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateRegisterPublication", header: "ValueFederate.h".}
## * register a publication with a defined type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##     @param type a string labeling the type of the publication
##     @param units a string listing the units of the subscription maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the publication
##

proc helicsFederateRegisterTypePublication*(fed: helics_federate; key: cstring;
    `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.cdecl,
    importc: "helicsFederateRegisterTypePublication", header: "ValueFederate.h".}
## * register a global named publication with an arbitrary type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##     @param type a code identifying the type of the input see /ref helics_data_type for available options
##     @param units a string listing the units of the subscription maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the publication
##

proc helicsFederateRegisterGlobalPublication*(fed: helics_federate; key: cstring;
    `type`: helics_data_type; units: cstring; err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateRegisterGlobalPublication",
    header: "ValueFederate.h".}
## * register a global publication with a defined type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##     @param type a string describing the expected type of the publication
##     @param units a string listing the units of the subscription maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the publication
##

proc helicsFederateRegisterGlobalTypePublication*(fed: helics_federate;
    key: cstring; `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateRegisterGlobalTypePublication",
    header: "ValueFederate.h".}
## * register a named input
##     @details the input becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions, inputs, and publications
##     @param fed the federate object in which to create an input
##     @param key the identifier for the publication the global input key will be prepended with the federate name
##     @param type a code identifying the type of the input see /ref helics_data_type for available options
##     @param units a string listing the units of the input maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the input
##

proc helicsFederateRegisterInput*(fed: helics_federate; key: cstring;
                                 `type`: helics_data_type; units: cstring;
                                 err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateRegisterInput", header: "ValueFederate.h".}
## * register an input with a defined type
##     @details the input becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions, inputs and publications
##     @param fed the federate object in which to create an input
##     @param key the identifier for the input
##     @param type a string describing the expected type of the input
##     @param units a string listing the units of the input maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the publication
##

proc helicsFederateRegisterTypeInput*(fed: helics_federate; key: cstring;
                                     `type`: cstring; units: cstring;
                                     err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateRegisterTypeInput", header: "ValueFederate.h".}
## * register a global named input
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##     @param type a code identifying the type of the input see /ref helics_data_type for available options
##     @param units a string listing the units of the subscription maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the publication
##

proc helicsFederateRegisterGlobalInput*(fed: helics_federate; key: cstring;
                                       `type`: helics_data_type; units: cstring;
                                       err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateRegisterGlobalInput", header: "ValueFederate.h".}
## * register a global publication with an arbitrary type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##    @param type a string defining the type of the input
##     @param units a string listing the units of the subscription maybe NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the publication
##

proc helicsFederateRegisterGlobalTypeInput*(fed: helics_federate; key: cstring;
    `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.cdecl,
    importc: "helicsFederateRegisterGlobalTypeInput", header: "ValueFederate.h".}
## * get a publication object from a key
##     @param fed the value federate object to use to get the publication
##     @param key the name of the publication
##     @forcpponly
##     @param[in,out] err the error object to complete if there is an error
##     @endforcpponly
##     @return a helics_publication object, the object will not be valid and err will contain an error code if no publication with the
##     specified key exists
##

proc helicsFederateGetPublication*(fed: helics_federate; key: cstring;
                                  err: ptr helics_error): helics_publication {.
    cdecl, importc: "helicsFederateGetPublication", header: "ValueFederate.h".}
## * get a publication by its index typically already created via registerInterfaces file or something of that nature
##     @param fed the federate object in which to create a publication
##     @param index the index of the publication to get
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return a helics_publication
##

proc helicsFederateGetPublicationByIndex*(fed: helics_federate; index: cint;
    err: ptr helics_error): helics_publication {.cdecl,
    importc: "helicsFederateGetPublicationByIndex", header: "ValueFederate.h".}
## * get an input object from a key
##     @param fed the value federate object to use to get the publication
##     @param key the name of the input
##     @forcpponly
##     @param[in,out] err the error object to complete if there is an error
##     @endforcpponly
##     @return a helics_input object, the object will not be valid and err will contain an error code if no input with the specified
##     key exists
##

proc helicsFederateGetInput*(fed: helics_federate; key: cstring;
                            err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateGetInput", header: "ValueFederate.h".}
## * get an input by its index typically already created via registerInterfaces file or something of that nature
##     @param fed the federate object in which to create a publication
##     @param index the index of the publication to get
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return a helics_input, which will be NULL if an invalid index
##

proc helicsFederateGetInputByIndex*(fed: helics_federate; index: cint;
                                   err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateGetInputByIndex", header: "ValueFederate.h".}
## * get an input object from a subscription target
##     @param fed the value federate object to use to get the publication
##     @param key the name of the publication that a subscription is targeting
##     @forcpponly
##     @param[in,out] err the error object to complete if there is an error
##     @endforcpponly
##     @return a helics_input object, the object will not be valid and err will contain an error code if no input with the specified
##     key exists
##

proc helicsFederateGetSubscription*(fed: helics_federate; key: cstring;
                                   err: ptr helics_error): helics_input {.cdecl,
    importc: "helicsFederateGetSubscription", header: "ValueFederate.h".}
## * clear all the update flags from a federates inputs
##

proc helicsFederateClearUpdates*(fed: helics_federate) {.cdecl,
    importc: "helicsFederateClearUpdates", header: "ValueFederate.h".}
## * register the publications via  JSON publication string
##     @details this would be the same JSON that would be used to publish data
##

proc helicsFederateRegisterFromPublicationJSON*(fed: helics_federate;
    json: cstring; err: ptr helics_error) {.cdecl, importc: "helicsFederateRegisterFromPublicationJSON",
                                       header: "ValueFederate.h".}
## * publish data contained in a json file or string

proc helicsFederatePublishJSON*(fed: helics_federate; json: cstring;
                               err: ptr helics_error) {.cdecl,
    importc: "helicsFederatePublishJSON", header: "ValueFederate.h".}
## *
##  \defgroup publications Publication functions
##     @details functions for publishing data of various kinds
##     The data will get translated to the type specified when the publication was constructed automatically
##     regardless of the function used to publish the data
##  @{
##
## * publish raw data from a char * and length
##     @param pub the publication to publish for
##     @param data a pointer to the raw data
##     @param inputDataLength the size in bytes of the data to publish
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishRaw*(pub: helics_publication; data: pointer;
                                 inputDataLength: cint; err: ptr helics_error) {.
    cdecl, importc: "helicsPublicationPublishRaw", header: "ValueFederate.h".}
## * publish a string
##     @param pub the publication to publish for
##     @param str a pointer to a NULL terminated string
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishString*(pub: helics_publication; str: cstring;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishString", header: "ValueFederate.h".}
## * publish an integer value
##     @param pub the publication to publish for
##     @param val the numerical value to publish
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishInteger*(pub: helics_publication; val: int64_t;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishInteger", header: "ValueFederate.h".}
## * publish a Boolean Value
##     @param pub the publication to publish for
##     @param val the boolean value to publish either helics_true or helics_false
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishBoolean*(pub: helics_publication; val: helics_bool;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishBoolean", header: "ValueFederate.h".}
## * publish a double floating point value
##     @param pub the publication to publish for
##     @param val the numerical value to publish
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishDouble*(pub: helics_publication; val: cdouble;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishDouble", header: "ValueFederate.h".}
## * publish a time value
##     @param pub the publication to publish for
##     @param val the numerical value to publish
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishTime*(pub: helics_publication; val: helics_time;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishTime", header: "ValueFederate.h".}
## * publish a single character
##     @param pub the publication to publish for
##     @param val the numerical value to publish
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishChar*(pub: helics_publication; val: char;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishChar", header: "ValueFederate.h".}
## * publish a complex value (or pair of values)
##     @param pub the publication to publish for
##     @param real the real part of a complex number to publish
##     @param imag the imaginary part of a complex number to publish
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishComplex*(pub: helics_publication; real: cdouble;
                                     imag: cdouble; err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishComplex", header: "ValueFederate.h".}
## * publish a vector of doubles
##     @param pub the publication to publish for
##     @param vectorInput a pointer to an array of double data
##     @param vectorLength the number of points to publish
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishVector*(pub: helics_publication;
                                    vectorInput: ptr cdouble; vectorLength: cint;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishVector", header: "ValueFederate.h".}
## * publish a named point
##     @param pub the publication to publish for
##     @param str a pointer a null terminated string
##     @param val a double val to publish
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationPublishNamedPoint*(pub: helics_publication; str: cstring;
                                        val: cdouble; err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationPublishNamedPoint", header: "ValueFederate.h".}
## * add a named input to the list of targets a publication publishes to
##     @param pub the publication to add the target for
##     @param target the name of an input that the data should be sent to
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsPublicationAddTarget*(pub: helics_publication; target: cstring;
                                err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationAddTarget", header: "ValueFederate.h".}
## * add a publication to the list of data that an input subscribes to
##     @param ipt the named input to modify
##     @param target the name of a publication that an input should subscribe to
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsInputAddTarget*(ipt: helics_input; target: cstring; err: ptr helics_error) {.
    cdecl, importc: "helicsInputAddTarget", header: "ValueFederate.h".}
## *@}
## *
##  \defgroup getValue GetValue functions
##     @details data can be returned in number of formats,  for instance if data is published as a double it can be returned as a string and
##     vice versa,  not all translations make that much sense but they do work.
##  @{
##
## * get the size of the raw value for subscription
##     @returns the size of the raw data/string in bytes
##

proc helicsInputGetRawValueSize*(ipt: helics_input): cint {.cdecl,
    importc: "helicsInputGetRawValueSize", header: "ValueFederate.h".}
## * get the raw data for the latest value of a subscription
##     @param ipt the input to get the data for
##     @param[out] data the memory location of the data
##     @param maxDatalen the maximum size of information that data can hold
##     @param[out] actualSize  the actual length of data copied to data
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsInputGetRawValue*(ipt: helics_input; data: pointer; maxDatalen: cint;
                            actualSize: ptr cint; err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetRawValue", header: "ValueFederate.h".}
## * get the size of a value for subscription assuming return as a string
##     @returns the size of the string
##

proc helicsInputGetStringSize*(ipt: helics_input): cint {.cdecl,
    importc: "helicsInputGetStringSize", header: "ValueFederate.h".}
## * get a string value from a subscription
##     @param ipt the input to get the data for
##     @param[out] outputString storage for copying a null terminated string
##     @param maxStringLen the maximum size of information that str can hold
##     @param[out] actualLength the actual length of the string
##     @forcpponly
##     @param[in,out] err error term for capturing errors
##     @endforcpponly
##

proc helicsInputGetString*(ipt: helics_input; outputString: cstring;
                          maxStringLen: cint; actualLength: ptr cint;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetString", header: "ValueFederate.h".}
## * get an integer value from a subscription
##     @param ipt the input to get the data for
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an int64_t value with the current value of the input
##

proc helicsInputGetInteger*(ipt: helics_input; err: ptr helics_error): int64_t {.cdecl,
    importc: "helicsInputGetInteger", header: "ValueFederate.h".}
## * get a boolean value from a subscription
##     @param ipt the input to get the data for
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return a boolean value of current input value
##

proc helicsInputGetBoolean*(ipt: helics_input; err: ptr helics_error): helics_bool {.
    cdecl, importc: "helicsInputGetBoolean", header: "ValueFederate.h".}
## * get a double value from a subscription
##     @param ipt the input to get the data for
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return the double value of the input
##

proc helicsInputGetDouble*(ipt: helics_input; err: ptr helics_error): cdouble {.cdecl,
    importc: "helicsInputGetDouble", header: "ValueFederate.h".}
## * get a double value from a subscription
##     @param ipt the input to get the data for
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return the resulting double value
##

proc helicsInputGetTime*(ipt: helics_input; err: ptr helics_error): helics_time {.
    cdecl, importc: "helicsInputGetTime", header: "ValueFederate.h".}
## * get a single character value from an input
##     @param ipt the input to get the data for
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return the resulting character value
##     //NAK (negative acknowledgment) symbol returned on error
##

proc helicsInputGetChar*(ipt: helics_input; err: ptr helics_error): char {.cdecl,
    importc: "helicsInputGetChar", header: "ValueFederate.h".}
## * get a complex object from an input object
##     @param ipt the input to get the data for
##     @forcpponly
##     @param[in,out] err a helics error object, if the object is not empty the function is bypassed otherwise it is filled in if there is an
##     @endforcpponly
##     error
##     @return a helics_complex structure with the value
##

proc helicsInputGetComplexObject*(ipt: helics_input; err: ptr helics_error): helics_complex {.
    cdecl, importc: "helicsInputGetComplexObject", header: "ValueFederate.h".}
## * get a pair of double forming a complex number from a subscriptions
##     @param ipt the input to get the data for
##     @param[out] real memory location to place the real part of a value
##     @param[out] imag memory location to place the imaginary part of a value
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function.
##     On error the values will not be altered.
##     @endforcpponly
##

proc helicsInputGetComplex*(ipt: helics_input; real: ptr cdouble; imag: ptr cdouble;
                           err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetComplex", header: "ValueFederate.h".}
## * get the size of a value for subscription assuming return as an array of doubles
##     @returns the number of double in a return vector
##

proc helicsInputGetVectorSize*(ipt: helics_input): cint {.cdecl,
    importc: "helicsInputGetVectorSize", header: "ValueFederate.h".}
## * get a vector from a subscription
##     @param ipt the input to get the result for
##     @param[out] data the location to store the data
##     @param maxlen the maximum size of the vector
##     @param[out] actualSize location to place the actual length of the resulting vector
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputGetVector*(ipt: helics_input; data: ptr cdouble; maxlen: cint;
                          actualSize: ptr cint; err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetVector", header: "ValueFederate.h".}
## * get a named point from a subscription
##     @param ipt the input to get the result for
##     @param[out] outputString storage for copying a null terminated string
##     @param maxStringLen the maximum size of information that str can hold
##     @param[out] actualLength the actual length of the string
##     @param[out] val the double value for the named point
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputGetNamedPoint*(ipt: helics_input; outputString: cstring;
                              maxStringLen: cint; actualLength: ptr cint;
                              val: ptr cdouble; err: ptr helics_error) {.cdecl,
    importc: "helicsInputGetNamedPoint", header: "ValueFederate.h".}
## *@}
## *
##  \defgroup default_values Default Value functions
##     @details these functions set the default value for a subscription. That is the value returned if nothing was published from elsewhere
##  @{
##
## * set the default as a raw data array
##     @param ipt the input to set the default for
##     @param data a pointer to the raw data to use for the default
##     @param inputDataLength the size of the raw data
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultRaw*(ipt: helics_input; data: pointer;
                              inputDataLength: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultRaw", header: "ValueFederate.h".}
## * set the default as a string
##     @param ipt the input to set the default for
##     @param str a pointer to the default string
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultString*(ipt: helics_input; str: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultString", header: "ValueFederate.h".}
## * set the default as an integer
##     @param ipt the input to set the default for
##     @param val the default integer
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultInteger*(ipt: helics_input; val: int64_t;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultInteger", header: "ValueFederate.h".}
## * set the default as a boolean
##     @param ipt the input to set the default for
##     @param val the default boolean value
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultBoolean*(ipt: helics_input; val: helics_bool;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultBoolean", header: "ValueFederate.h".}
## * set the default as a double
##     @param ipt the input to set the default for
##     @param val the default double value
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the
##      @endforcpponly
##     function
##

proc helicsInputSetDefaultTime*(ipt: helics_input; val: helics_time;
                               err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultTime", header: "ValueFederate.h".}
## * set the default as a double
##     @param ipt the input to set the default for
##     @param val the default double value
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultChar*(ipt: helics_input; val: char; err: ptr helics_error) {.
    cdecl, importc: "helicsInputSetDefaultChar", header: "ValueFederate.h".}
## * set the default as a double
##     @param ipt the input to set the default for
##     @param val the default double value
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultDouble*(ipt: helics_input; val: cdouble;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultDouble", header: "ValueFederate.h".}
## * set the default as a complex number
##     @param ipt the input to set the default for
##     @param real the default real value
##     @param imag the default imaginary value
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultComplex*(ipt: helics_input; real: cdouble; imag: cdouble;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultComplex", header: "ValueFederate.h".}
## * set the default as a vector of doubles
##     @param ipt the input to set the default for
##     @param vectorInput a pointer to an array of double data
##     @param vectorLength the number of points to publish
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultVector*(ipt: helics_input; vectorInput: ptr cdouble;
                                 vectorLength: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultVector", header: "ValueFederate.h".}
## * set the default as a NamedPoint
##     @param ipt the input to set the default for
##     @param str a pointer to a string representing the name
##     @param val a double value for the value of the named point
##     @forcpponly
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @endforcpponly
##

proc helicsInputSetDefaultNamedPoint*(ipt: helics_input; str: cstring; val: cdouble;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetDefaultNamedPoint", header: "ValueFederate.h".}
## *@}
## *
##  \defgroup information retrieval
##  @{
##
## * get the type of an input
##     @param ipt the input to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsInputGetType*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetType", header: "ValueFederate.h".}
## * get the type of the publisher to an input is sending
##     @param ipt the input to query
##     @return a const char * with the type name

proc helicsInputGetPublicationType*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetPublicationType", header: "ValueFederate.h".}
## * get the type of a publication
##     @param pub the publication to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsPublicationGetType*(pub: helics_publication): cstring {.cdecl,
    importc: "helicsPublicationGetType", header: "ValueFederate.h".}
## * get the key of an input
##     @param ipt the input to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsInputGetKey*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetKey", header: "ValueFederate.h".}
## * get the key of a subscription
##     @return a const char with the subscription key

proc helicsSubscriptionGetKey*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsSubscriptionGetKey", header: "ValueFederate.h".}
## * get the key of a publication
##     @details this will be the global key used to identify the publication to the federation
##     @param pub the publication to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsPublicationGetKey*(pub: helics_publication): cstring {.cdecl,
    importc: "helicsPublicationGetKey", header: "ValueFederate.h".}
## * get the units of an input
##     @param ipt the input to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsInputGetUnits*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetUnits", header: "ValueFederate.h".}
## * get the units of the publication that an input is linked to
##     @param ipt the input to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsInputGetInjectionUnits*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetInjectionUnits", header: "ValueFederate.h".}
## * get the units of an input
##     @details:  the same as helicsInputGetUnits
##     @param ipt the input to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsInputGetExtractionUnits*(ipt: helics_input): cstring {.cdecl,
    importc: "helicsInputGetExtractionUnits", header: "ValueFederate.h".}
## * get the units of a publication
##     @param pub the publication to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsPublicationGetUnits*(pub: helics_publication): cstring {.cdecl,
    importc: "helicsPublicationGetUnits", header: "ValueFederate.h".}
## * get the data in the info field of an input
##     @param inp the input to query
##     @return a string with the info field string

proc helicsInputGetInfo*(inp: helics_input): cstring {.cdecl,
    importc: "helicsInputGetInfo", header: "ValueFederate.h".}
## * set the data in the info field for an input
##     @param inp the input to query
##     @param info the string to set
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsInputSetInfo*(inp: helics_input; info: cstring; err: ptr helics_error) {.
    cdecl, importc: "helicsInputSetInfo", header: "ValueFederate.h".}
## * get the data in the info field of an publication
##     @param pub the publication to query
##     @return a string with the info field string

proc helicsPublicationGetInfo*(pub: helics_publication): cstring {.cdecl,
    importc: "helicsPublicationGetInfo", header: "ValueFederate.h".}
## * set the data in the info field for an publication
##     @param pub the publication to set the info field for
##     @param info the string to set
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsPublicationSetInfo*(pub: helics_publication; info: cstring;
                              err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationSetInfo", header: "ValueFederate.h".}
## * get the data in the info field of an input
##     @param inp the input to query
##     @param option integer representation of the option in question see /ref helics_handle_options
##     @return a string with the info field string

proc helicsInputGetOption*(inp: helics_input; option: cint): helics_bool {.cdecl,
    importc: "helicsInputGetOption", header: "ValueFederate.h".}
## * set the data in the info field for an input
##     @param inp the input to query
##     @param option the option to set for the input /ref helics_handle_options
##     @param value the value to set the option to
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsInputSetOption*(inp: helics_input; option: cint; value: helics_bool;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetOption", header: "ValueFederate.h".}
## * get the data in the info field of an publication
##     @param pub the publication to query
##     @param option the value to query see /ref helics_handle_options
##     @return a string with the info field string

proc helicsPublicationGetOption*(pub: helics_publication; option: cint): helics_bool {.
    cdecl, importc: "helicsPublicationGetOption", header: "ValueFederate.h".}
## * set the data in the info field for an publication
##     @param pub the publication to query
##     @param option integer code for the option to set /ref helics_handle_options
##     @param val the value to set the option to
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsPublicationSetOption*(pub: helics_publication; option: cint;
                                val: helics_bool; err: ptr helics_error) {.cdecl,
    importc: "helicsPublicationSetOption", header: "ValueFederate.h".}
## * set the minimum change detection tolerance
##     @param pub the publication to modify
##     @param tolerance the tolerance level for publication, values changing less than this value will not be published
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsPublicationSetMinimumChange*(pub: helics_publication;
                                       tolerance: cdouble; err: ptr helics_error) {.
    cdecl, importc: "helicsPublicationSetMinimumChange", header: "ValueFederate.h".}
## * set the minimum change detection tolerance
##     @param inp the input to modify
##     @param tolerance the tolerance level for registering an update, values changing less than this value will not show as being updated
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsInputSetMinimumChange*(inp: helics_input; tolerance: cdouble;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsInputSetMinimumChange", header: "ValueFederate.h".}
## *@}
## * check if a particular subscription was updated
##     @return true if it has been updated since the last value retrieval

proc helicsInputIsUpdated*(ipt: helics_input): helics_bool {.cdecl,
    importc: "helicsInputIsUpdated", header: "ValueFederate.h".}
## * get the last time a subscription was updated

proc helicsInputLastUpdateTime*(ipt: helics_input): helics_time {.cdecl,
    importc: "helicsInputLastUpdateTime", header: "ValueFederate.h".}
## * clear the updated flag from an input
##

proc helicsInputClearUpdate*(ipt: helics_input) {.cdecl,
    importc: "helicsInputClearUpdate", header: "ValueFederate.h".}
## * get the number of publications in a federate
##     @return (-1) if fed was not a valid federate otherwise returns the number of publications

proc helicsFederateGetPublicationCount*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederateGetPublicationCount", header: "ValueFederate.h".}
## * get the number of subscriptions in a federate
##     @return (-1) if fed was not a valid federate otherwise returns the number of subscriptions

proc helicsFederateGetInputCount*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederateGetInputCount", header: "ValueFederate.h".}
