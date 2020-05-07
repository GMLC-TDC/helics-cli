##
## Copyright (c) 2017-2019,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##
## * @file
## @brief functions related the message federates for the C api
##

import
  helics

##  MESSAGE FEDERATE calls
## * create an endpoint
##     @details the endpoint becomes part of the federate and is destroyed when the federate is freed so there are no separate free functions
##     for endpoints
##     @param fed the federate object in which to create an endpoint must have been create with helicsCreateMessageFederate or
##     helicsCreateCombinationFederate
##     @param name the identifier for the endpoint,  this will be prepended with the federate name for the global identifier
##     @param type a string describing the expected type of the publication may be NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the endpoint, nullptr on failure
##

proc helicsFederateRegisterEndpoint*(fed: helics_federate; name: cstring;
                                    `type`: cstring; err: ptr helics_error): helics_endpoint {.
    cdecl.}
## * create an endpoint
##     @details the endpoint becomes part of the federate and is destroyed when the federate is freed so there are no separate free functions
##     for endpoints
##     @param fed the federate object in which to create an endpoint must have been create with helicsCreateMessageFederate or
##     helicsCreateCombinationFederate
##     @param name the identifier for the endpoint,  the given name is the global identifier
##     @param type a string describing the expected type of the publication may be NULL
##     @param[in,out] err a pointer to an error object for catching errors
##     @return an object containing the endpoint, nullptr on failure
##

proc helicsFederateRegisterGlobalEndpoint*(fed: helics_federate; name: cstring;
    `type`: cstring; err: ptr helics_error): helics_endpoint {.cdecl.}
## * get an endpoint object from a name
##     @param fed the message federate object to use to get the endpoint
##     @param name the name of the endpoint
##     @param[in,out] err the error object to complete if there is an error
##     @return a helics_endpoint object, the object will not be valid and err will contain an error code if no endpoint with the specified
##     name exists
##

proc helicsFederateGetEndpoint*(fed: helics_federate; name: cstring;
                               err: ptr helics_error): helics_endpoint {.cdecl.}
## * get an endpoint by its index typically already created via registerInterfaces file or something of that nature
##
##     @param fed the federate object in which to create a publication
##     @param index the index of the publication to get
##     @param[in,out] err a pointer to an error object for catching errors
##     @return a helics_endpoint, which will be NULL if an invalid index
##

proc helicsFederateGetEndpointByIndex*(fed: helics_federate; index: cint;
                                      err: ptr helics_error): helics_endpoint {.
    cdecl.}
## * set the default destination for an endpoint if no other endpoint is given
##     @param endpoint the endpoint to set the destination for
##     @param dest a string naming the desired default endpoint
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsEndpointSetDefaultDestination*(endpoint: helics_endpoint; dest: cstring;
    err: ptr helics_error) {.cdecl.}
## * get the default destination for an endpoint
##     @param endpoint the endpoint to set the destination for
##     @return a string with the default destination
##

proc helicsEndpointGetDefaultDestination*(endpoint: helics_endpoint): cstring {.
    cdecl.}
## * send a message to the specified destination
##     @param endpoint the endpoint to send the data from
##     @param dest the target destination (nullptr to use the default destination)
##     @param data the data to send
##     @param inputDataLength the length of the data to send
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsEndpointSendMessageRaw*(endpoint: helics_endpoint; dest: cstring;
                                  data: pointer; inputDataLength: cint;
                                  err: ptr helics_error) {.cdecl.}
## * send a message at a specific time to the specified destination
##     @param endpoint the endpoint to send the data from
##     @param dest the target destination (nullptr to use the default destination
##     @param data the data to send
##     @param inputDataLength the length of the data to send
##     @param time the time the message should be sent
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsEndpointSendEventRaw*(endpoint: helics_endpoint; dest: cstring;
                                data: pointer; inputDataLength: cint;
                                time: helics_time; err: ptr helics_error) {.cdecl.}
## * send a message object from a specific endpoint
##     @param endpoint the endpoint to send the data from
##     @param message the actual message to send
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsEndpointSendMessage*(endpoint: helics_endpoint;
                               message: ptr helics_message; err: ptr helics_error) {.
    cdecl.}
## * subscribe an endpoint to a publication
##     @param endpoint the endpoint to use
##     @param key the name of the publication
##     @param[in,out] err a pointer to an error object for catching errors
##

proc helicsEndpointSubscribe*(endpoint: helics_endpoint; key: cstring;
                             err: ptr helics_error) {.cdecl.}
## * check if the federate has any outstanding messages
##     @param fed the federate to check if it has
##     @return helics_true if the federate has a message waiting helics_false otherwise

proc helicsFederateHasMessage*(fed: helics_federate): helics_bool {.cdecl.}
## * check if a given endpoint has any unread messages
##     @param endpoint the endpoint to check
##     @return helics_true if the endpoint has a message, helics_false otherwise

proc helicsEndpointHasMessage*(endpoint: helics_endpoint): helics_bool {.cdecl.}
## *
##  Returns the number of pending receives for the specified destination endpoint.
##      @param fed the federate to get the number of waiting messages
##

proc helicsFederatePendingMessages*(fed: helics_federate): cint {.cdecl.}
## *
##  Returns the number of pending receives for all endpoints of particular federate.
##      @param endpoint the endpoint to query
##

proc helicsEndpointPendingMessages*(endpoint: helics_endpoint): cint {.cdecl.}
## * receive a packet from a particular endpoint
##     @param[in] endpoint the identifier for the endpoint
##     @return a message object

proc helicsEndpointGetMessage*(endpoint: helics_endpoint): helics_message {.cdecl.}
## * receive a communication message for any endpoint in the federate
##     @details the return order will be in order of endpoint creation then order of arrival
##     all messages for the first endpoint, then all for the second, and so on
##     within a single endpoint the messages are ordered by time, then source_id, then order of arrival
##     @return a unique_ptr to a Message object containing the message data

proc helicsFederateGetMessage*(fed: helics_federate): helics_message {.cdecl.}
## * get the type specified for an endpoint
##     @param endpoint  the endpoint object in question
##     @return the defined type of the endpoint
##

proc helicsEndpointGetType*(endpoint: helics_endpoint): cstring {.cdecl.}
## * get the name of an endpoint
##     @param endpoint  the endpoint object in question
##     @return the name of the endpoint
##

proc helicsEndpointGetName*(endpoint: helics_endpoint): cstring {.cdecl.}
## * get the number of endpoints in a federate
##     @param fed the message federate to query
##     @return (-1) if fed was not a valid federate otherwise returns the number of endpoints

proc helicsFederateGetEndpointCount*(fed: helics_federate): cint {.cdecl.}
## * get the data in the info field of an filter
##     @param end the filter to query
##     @return a string with the info field string

proc helicsEndpointGetInfo*(`end`: helics_endpoint): cstring {.cdecl.}
## * set the data in the info field for an filter
##     @param end the endpoint to query
##     @param info the string to set
##     @param[in,out] err an error object to fill out in case of an error

proc helicsEndpointSetInfo*(`end`: helics_endpoint; info: cstring;
                           err: ptr helics_error) {.cdecl.}
## * set a handle option on an endpoint
##     @param end the endpoint to modify
##     @param option integer code for the option to set /ref helics_handle_options
##     @param value the value to set the option
##     @param[in,out] err an error object to fill out in case of an error

proc helicsEndpointSetOption*(`end`: helics_endpoint; option: cint;
                             value: helics_bool; err: ptr helics_error) {.cdecl.}
## * set a handle option on an endpoint
##     @param end the endpoint to modify
##     @param option integer code for the option to set /ref helics_handle_options
##

proc helicsEndpointGetOption*(`end`: helics_endpoint; option: cint): helics_bool {.
    cdecl.}
