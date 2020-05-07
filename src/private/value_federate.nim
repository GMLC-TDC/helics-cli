##
## Copyright (c) 2017-2019,
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
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the subscription
##

proc helicsFederateRegisterSubscription*(fed: helics_federate; key: cstring;
                                        units: cstring; err: ptr helics_error): helics_input {.
    cdecl.}
## * register a publication with a a known type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication the global publication key will be prepended with the federate name
##     @param type a code identifying the type of the input see /ref helics_data_type for available options
##     @param units a string listing the units of the subscription maybe NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the publication
##

proc helicsFederateRegisterPublication*(fed: helics_federate; key: cstring;
                                       `type`: helics_data_type; units: cstring;
                                       err: ptr helics_error): helics_publication {.
    cdecl.}
## * register a publication with a defined type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##     @param type a string labeling the type of the publication
##     @param units a string listing the units of the subscription maybe NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the publication
##

proc helicsFederateRegisterTypePublication*(fed: helics_federate; key: cstring;
    `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.cdecl.}
## * register a global named publication with an arbitrary type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##     @param type a code identifying the type of the input see /ref helics_data_type for available options
##     @param units a string listing the units of the subscription maybe NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the publication
##

proc helicsFederateRegisterGlobalPublication*(fed: helics_federate; key: cstring;
    `type`: helics_data_type; units: cstring; err: ptr helics_error): helics_publication {.
    cdecl.}
## * register a global publication with a defined type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##     @param type a string describing the expected type of the publication
##     @param units a string listing the units of the subscription maybe NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the publication
##

proc helicsFederateRegisterGlobalTypePublication*(fed: helics_federate;
    key: cstring; `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.
    cdecl.}
## * register a named input
##     @details the input becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions, inputs, and publications
##     @param fed the federate object in which to create an input
##     @param key the identifier for the publication the global input key will be prepended with the federate name
##     @param type a code identifying the type of the input see /ref helics_data_type for available options
##     @param units a string listing the units of the input maybe NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the input
##

proc helicsFederateRegisterInput*(fed: helics_federate; key: cstring;
                                 `type`: helics_data_type; units: cstring;
                                 err: ptr helics_error): helics_input {.cdecl.}
## * register an input with a defined type
##     @details the input becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions, inputs and publications
##     @param fed the federate object in which to create an input
##     @param key the identifier for the input
##     @param type a string describing the expected type of the input
##     @param units a string listing the units of the input maybe NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the publication
##

proc helicsFederateRegisterTypeInput*(fed: helics_federate; key: cstring;
                                     `type`: cstring; units: cstring;
                                     err: ptr helics_error): helics_input {.cdecl.}
## * register a global named input
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##     @param type a code identifying the type of the input see /ref helics_data_type for available options
##     @param units a string listing the units of the subscription maybe NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the publication
##

proc helicsFederateRegisterGlobalInput*(fed: helics_federate; key: cstring;
                                       `type`: helics_data_type; units: cstring;
                                       err: ptr helics_error): helics_publication {.
    cdecl.}
## * register a global publication with an arbitrary type
##     @details the publication becomes part of the federate and is destroyed when the federate is freed so there are no separate free
##     functions for subscriptions and publications
##     @param fed the federate object in which to create a publication
##     @param key the identifier for the publication
##    @param type a string defining the type of the input
##     @param units a string listing the units of the subscription maybe NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the publication
##

proc helicsFederateRegisterGlobalTypeInput*(fed: helics_federate; key: cstring;
    `type`: cstring; units: cstring; err: ptr helics_error): helics_publication {.cdecl.}
## * get a publication object from a key
##     @param fed the value federate object to use to get the publication
##     @param key the name of the publication
##     @param[in,out] err the error object to complete if there is an error
##     @return a helics_publication object, the object will not be valid and err will contain an error code if no publication with the
##     specified key exists
##

proc helicsFederateGetPublication*(fed: helics_federate; key: cstring;
                                  err: ptr helics_error): helics_publication {.cdecl.}
## * get a publication by its index typically already created via registerInterfaces file or something of that nature
##     @param fed the federate object in which to create a publication
##     @param index the index of the publication to get
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_publication
##

proc helicsFederateGetPublicationByIndex*(fed: helics_federate; index: cint;
    err: ptr helics_error): helics_publication {.cdecl.}
## * get an input object from a key
##     @param fed the value federate object to use to get the publication
##     @param key the name of the input
##     @param[in,out] err the error object to complete if there is an error
##     @return a helics_input object, the object will not be valid and err will contain an error code if no input with the specified
##     key exists
##

proc helicsFederateGetInput*(fed: helics_federate; key: cstring;
                            err: ptr helics_error): helics_input {.cdecl.}
## * get an input by its index typically already created via registerInterfaces file or something of that nature
##     @param fed the federate object in which to create a publication
##     @param index the index of the publication to get
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_input, which will be NULL if an invalid index
##

proc helicsFederateGetInputByIndex*(fed: helics_federate; index: cint;
                                   err: ptr helics_error): helics_input {.cdecl.}
## * get an input object from a subscription target
##     @param fed the value federate object to use to get the publication
##     @param key the name of the publication that a subscription is targeting
##     @param[in,out] err the error object to complete if there is an error
##     @return a helics_input object, the object will not be valid and err will contain an error code if no input with the specified
##     key exists
##

proc helicsFederateGetSubscription*(fed: helics_federate; key: cstring;
                                   err: ptr helics_error): helics_input {.cdecl.}
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
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishRaw*(pub: helics_publication; data: pointer;
                                 inputDataLength: cint; err: ptr helics_error) {.
    cdecl.}
## * publish a string
##     @param pub the publication to publish for
##     @param str a pointer to a NULL terminated string
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishString*(pub: helics_publication; str: cstring;
                                    err: ptr helics_error) {.cdecl.}
## * publish an integer value
##     @param pub the publication to publish for
##     @param val the numerical value to publish
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishInteger*(pub: helics_publication; val: int64_t;
                                     err: ptr helics_error) {.cdecl.}
## * publish a Boolean Value
##     @param pub the publication to publish for
##     @param val the boolean value to publish either helics_true or helics_false
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishBoolean*(pub: helics_publication; val: helics_bool;
                                     err: ptr helics_error) {.cdecl.}
## * publish a double floating point value
##     @param pub the publication to publish for
##     @param val the numerical value to publish
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishDouble*(pub: helics_publication; val: cdouble;
                                    err: ptr helics_error) {.cdecl.}
## * publish a time value
##     @param pub the publication to publish for
##     @param val the numerical value to publish
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishTime*(pub: helics_publication; val: helics_time;
                                  err: ptr helics_error) {.cdecl.}
## * publish a single character
##     @param pub the publication to publish for
##     @param val the numerical value to publish
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishChar*(pub: helics_publication; val: char;
                                  err: ptr helics_error) {.cdecl.}
## * publish a complex value (or pair of values)
##     @param pub the publication to publish for
##     @param real the real part of a complex number to publish
##     @param imag the imaginary part of a complex number to publish
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishComplex*(pub: helics_publication; real: cdouble;
                                     imag: cdouble; err: ptr helics_error) {.cdecl.}
## * publish a vector of doubles
##     @param pub the publication to publish for
##     @param vectorInput a pointer to an array of double data
##     @param vectorLength the number of points to publish
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishVector*(pub: helics_publication;
                                    vectorInput: ptr cdouble; vectorLength: cint;
                                    err: ptr helics_error) {.cdecl.}
## * publish a named point
##     @param pub the publication to publish for
##     @param str a pointer a null terminated string
##     @param val a double val to publish
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationPublishNamedPoint*(pub: helics_publication; str: cstring;
                                        val: cdouble; err: ptr helics_error) {.cdecl.}
## * add a named input to the list of targets a publication publishes to
##     @param pub the publication to add the target for
##     @param target the name of an input that the data should be sent to
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsPublicationAddTarget*(pub: helics_publication; target: cstring;
                                err: ptr helics_error) {.cdecl.}
## * add a publication to the list of data that an input subscribes to
##     @param ipt the named input to modify
##     @param target the name of a publication that an input should subscribe to
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsInputAddTarget*(ipt: helics_input; target: cstring; err: ptr helics_error) {.
    cdecl.}
## *@}
## *
##  \defgroup getValue GetValue functions
##     @details data can be returned in number of formats,  for instance if data is published as a double it can be returned as a string
##     and vice versa,  not all translations make that much sense but they do work.
##  @{
##
## * get the size of the raw value for subscription
##     @returns the size of the raw data/string in bytes
##

proc helicsInputGetRawValueSize*(ipt: helics_input): cint {.cdecl.}
## * get the raw data for the latest value of a subscription
##     @param ipt the input to get the data for
##     @param[out] data the memory location of the data
##     @param maxlen the maximum size of information that data can hold
##     @param[out] actualSize  the actual length of data copied to data
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsInputGetRawValue*(ipt: helics_input; data: pointer; maxlen: cint;
                            actualSize: ptr cint; err: ptr helics_error) {.cdecl.}
## * get the size of a value for subscription assuming return as a string
##     @returns the size of the string
##

proc helicsInputGetStringSize*(ipt: helics_input): cint {.cdecl.}
## * get a string value from a subscription
##     @param ipt the input to get the data for
##     @param[out] outputString storage for copying a null terminated string
##     @param maxStringLen the maximum size of information that str can hold
##     @param[out] actualLength the actual length of the string
##     @param[in,out] err error term for capturing errors
##

proc helicsInputGetString*(ipt: helics_input; outputString: cstring;
                          maxStringLen: cint; actualLength: ptr cint;
                          err: ptr helics_error) {.cdecl.}
## * get an integer value from a subscription
##     @param ipt the input to get the data for
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an int64_t value with the current value of the input
##

proc helicsInputGetInteger*(ipt: helics_input; err: ptr helics_error): int64_t {.cdecl.}
## * get a boolean value from a subscription
##     @param ipt the input to get the data for
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a boolean value of current input value
##

proc helicsInputGetBoolean*(ipt: helics_input; err: ptr helics_error): helics_bool {.
    cdecl.}
## * get a double value from a subscription
##     @param ipt the input to get the data for
##     @param[in,out] err a pointer to an error object for catching errors
##     @return the double value of the input
##

proc helicsInputGetDouble*(ipt: helics_input; err: ptr helics_error): cdouble {.cdecl.}
## * get a double value from a subscription
##     @param ipt the input to get the data for
##     @param[in,out] err a pointer to an error object for catching errors
##     @return the resulting double value
##

proc helicsInputGetTime*(ipt: helics_input; err: ptr helics_error): helics_time {.cdecl.}
## * get a single character value from an input
##     @param ipt the input to get the data for
##     @param[in,out] err a pointer to an error object for catching errors
##     @return the resulting character value
##

proc helicsInputGetChar*(ipt: helics_input; err: ptr helics_error): char {.cdecl.}
## * get a complex object from an input object
##     @param ipt the input to get the data for
##     @param[in,out] err a helic error object, if the object is not empty the function is bypassed otherwise it is filled in if there is an
##     error
##     @return a helics_complex structure with the value
##

proc helicsInputGetComplexObject*(ipt: helics_input; err: ptr helics_error): helics_complex {.
    cdecl.}
## * get a pair of double forming a complex number from a subscriptions
##     @param ipt the input to get the data for
##     @param[out] real memory location to place the real part of a value
##     @param[out] imag memory location to place the imaginary part of a value
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputGetComplex*(ipt: helics_input; real: ptr cdouble; imag: ptr cdouble;
                           err: ptr helics_error) {.cdecl.}
## * get the size of a value for subscription assuming return as an array of doubles
##     @returns the number of double in a return vector
##

proc helicsInputGetVectorSize*(ipt: helics_input): cint {.cdecl.}
## * get a vector from a subscription
##     @param ipt the input to get the result for
##     @param[out] data the location to store the data
##     @param maxlen the maximum size of the vector
##     @param[out] actualSize location to place the actual length of the resulting vector
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputGetVector*(ipt: helics_input; data: ptr cdouble; maxlen: cint;
                          actualSize: ptr cint; err: ptr helics_error) {.cdecl.}
## * get a named point from a subscription
##     @param ipt the input to get the result for
##     @param[out] outputString storage for copying a null terminated string
##     @param maxStringLen the maximum size of information that str can hold
##     @param[out] actualLength the actual length of the string
##     @param[out] val the double value for the named point
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputGetNamedPoint*(ipt: helics_input; outputString: cstring;
                              maxStringLen: cint; actualLength: ptr cint;
                              val: ptr cdouble; err: ptr helics_error) {.cdecl.}
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
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputSetDefaultRaw*(ipt: helics_input; data: pointer;
                              inputDataLength: cint; err: ptr helics_error) {.cdecl.}
## * set the default as a string
##     @param ipt the input to set the default for
##     @param str a pointer to the default string
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputSetDefaultString*(ipt: helics_input; str: cstring;
                                 err: ptr helics_error) {.cdecl.}
## * set the default as an integer
##     @param ipt the input to set the default for
##     @param val the default integer
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputSetDefaultInteger*(ipt: helics_input; val: int64_t;
                                  err: ptr helics_error) {.cdecl.}
## * set the default as a boolean
##     @param ipt the input to set the default for
##     @param val the default boolean value
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputSetDefaultBoolean*(ipt: helics_input; val: helics_bool;
                                  err: ptr helics_error) {.cdecl.}
## * set the default as a double
##     @param ipt the input to set the default for
##     @param val the default double value
##      @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the
##     function
##

proc helicsInputSetDefaultTime*(ipt: helics_input; val: helics_time;
                               err: ptr helics_error) {.cdecl.}
## * set the default as a double
##     @param ipt the input to set the default for
##     @param val the default double value
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputSetDefaultChar*(ipt: helics_input; val: char; err: ptr helics_error) {.
    cdecl.}
## * set the default as a double
##     @param ipt the input to set the default for
##     @param val the default double value
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputSetDefaultDouble*(ipt: helics_input; val: cdouble;
                                 err: ptr helics_error) {.cdecl.}
## * set the default as a complex number
##     @param ipt the input to set the default for
##     @param real the default real value
##     @param imag the default imaginary value
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputSetDefaultComplex*(ipt: helics_input; real: cdouble; imag: cdouble;
                                  err: ptr helics_error) {.cdecl.}
## * set the default as a vector of doubles
##     @param ipt the input to set the default for
##     @param vectorInput a pointer to an array of double data
##     @param vectorLength the number of points to publish
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##

proc helicsInputSetDefaultVector*(ipt: helics_input; vectorInput: ptr cdouble;
                                 vectorLength: cint; err: ptr helics_error) {.cdecl.}
## * set the default as a NamedPoint
##     @param ipt the input to set the default for
##     @param str a pointer to a string representing the name
##     @param val a double value for the value of the named point
##     @param[in,out] err an error object that will contain an error code and string if any error occurred during the execution of the function
##     @return helics_ok if everything was OK
##

proc helicsInputSetDefaultNamedPoint*(ipt: helics_input; str: cstring; val: cdouble;
                                     err: ptr helics_error) {.cdecl.}
## *@}
## *
##  \defgroup information retrieval
##  @{
##
## * get the type of an input
##     @param ipt the input to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsInputGetType*(ipt: helics_input): cstring {.cdecl.}
## * get the type of the publisher to an input is sending
##     @param ipt the input to query
##     @return a const char * with the type name

proc helicsInputGetPublicationType*(ipt: helics_input): cstring {.cdecl.}
## * get the type of a publication
##     @param pub the publication to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsPublicationGetType*(pub: helics_publication): cstring {.cdecl.}
## * get the key of an input
##     @param ipt the input to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsInputGetKey*(ipt: helics_input): cstring {.cdecl.}
## * get the key of a subscription
##     @return a const char with the subscription key

proc helicsSubscriptionGetKey*(ipt: helics_input): cstring {.cdecl.}
## * get the key of a publication
##     @details this will be the global key used to identify the publication to the federation
##     @param pub the publication to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsPublicationGetKey*(pub: helics_publication): cstring {.cdecl.}
## * get the units of an input
##     @param ipt the input to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsInputGetUnits*(ipt: helics_input): cstring {.cdecl.}
## * get the units of a publication
##     @param pub the publication to query
##     @return a void enumeration, helics_ok if everything worked

proc helicsPublicationGetUnits*(pub: helics_publication): cstring {.cdecl.}
## * get the data in the info field of an input
##     @param inp the input to query
##     @return a string with the info field string

proc helicsInputGetInfo*(inp: helics_input): cstring {.cdecl.}
## * set the data in the info field for an input
##     @param inp the input to query
##     @param info the string to set
##     @param[in,out] err an error object to fill out in case of an error

proc helicsInputSetInfo*(inp: helics_input; info: cstring; err: ptr helics_error) {.
    cdecl.}
## * get the data in the info field of an publication
##     @param pub the publication to query
##     @return a string with the info field string

proc helicsPublicationGetInfo*(pub: helics_publication): cstring {.cdecl.}
## * set the data in the info field for an publication
##     @param pub the publication to set the info field for
##     @param info the string to set
##     @param[in,out] err an error object to fill out in case of an error

proc helicsPublicationSetInfo*(pub: helics_publication; info: cstring;
                              err: ptr helics_error) {.cdecl.}
## * get the data in the info field of an input
##     @param inp the input to query
##     @param option integer representation of the option in question see /ref helics_handle_options
##     @return a string with the info field string

proc helicsInputGetOption*(inp: helics_input; option: cint): helics_bool {.cdecl.}
## * set the data in the info field for an input
##     @param inp the input to query
##     @param option the option to set for the input /ref helics_handle_options
##     @param value the value to set the option to
##     @param[in,out] err an error object to fill out in case of an error

proc helicsInputSetOption*(inp: helics_input; option: cint; value: helics_bool;
                          err: ptr helics_error) {.cdecl.}
## * get the data in the info field of an publication
##     @param pub the publication to query
##     @param option the value to query see /ref helics_handle_options
##     @return a string with the info field string

proc helicsPublicationGetOption*(pub: helics_publication; option: cint): helics_bool {.
    cdecl.}
## * set the data in the info field for an publication
##     @param pub the publication to query
##     @param option integer code for the option to set /ref helics_handle_options
##     @param val the value to set the option to
##     @param[in,out] err an error object to fill out in case of an error

proc helicsPublicationSetOption*(pub: helics_publication; option: cint;
                                val: helics_bool; err: ptr helics_error) {.cdecl.}
## *@}
## * check if a particular subscription was updated
##     @return true if it has been updated since the last value retrieval

proc helicsInputIsUpdated*(ipt: helics_input): helics_bool {.cdecl.}
## * get the last time a subscription was updated

proc helicsInputLastUpdateTime*(ipt: helics_input): helics_time {.cdecl.}
## * get the number of publications in a federate
##     @return (-1) if fed was not a valid federate otherwise returns the number of publications

proc helicsFederateGetPublicationCount*(fed: helics_federate): cint {.cdecl.}
## * get the number of subscriptions in a federate
##     @return (-1) if fed was not a valid federate otherwise returns the number of subscriptions

proc helicsFederateGetInputCount*(fed: helics_federate): cint {.cdecl.}
