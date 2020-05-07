##
## Copyright (c) 2017-2020,
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
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the endpoint, nullptr on failure
##

proc helicsFederateRegisterEndpoint*(fed: helics_federate; name: cstring;
                                    `type`: cstring; err: ptr helics_error): helics_endpoint {.
    cdecl, importc: "helicsFederateRegisterEndpoint", header: "MessageFederate.h".}
## * create an endpoint
##     @details the endpoint becomes part of the federate and is destroyed when the federate is freed so there are no separate free functions
##     for endpoints
##     @param fed the federate object in which to create an endpoint must have been create with helicsCreateMessageFederate or
##     helicsCreateCombinationFederate
##     @param name the identifier for the endpoint,  the given name is the global identifier
##     @param type a string describing the expected type of the publication may be NULL
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return an object containing the endpoint, nullptr on failure
##

proc helicsFederateRegisterGlobalEndpoint*(fed: helics_federate; name: cstring;
    `type`: cstring; err: ptr helics_error): helics_endpoint {.cdecl,
    importc: "helicsFederateRegisterGlobalEndpoint", header: "MessageFederate.h".}
## * get an endpoint object from a name
##     @param fed the message federate object to use to get the endpoint
##     @param name the name of the endpoint
##     @forcpponly
##     @param[in,out] err the error object to complete if there is an error
##     @endforcpponly
##     @return a helics_endpoint object, the object will not be valid and err will contain an error code if no endpoint with the specified
##     name exists
##

proc helicsFederateGetEndpoint*(fed: helics_federate; name: cstring;
                               err: ptr helics_error): helics_endpoint {.cdecl,
    importc: "helicsFederateGetEndpoint", header: "MessageFederate.h".}
## * get an endpoint by its index typically already created via registerInterfaces file or something of that nature
##
##     @param fed the federate object in which to create a publication
##     @param index the index of the publication to get
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##     @return a helics_endpoint, which will be NULL if an invalid index
##

proc helicsFederateGetEndpointByIndex*(fed: helics_federate; index: cint;
                                      err: ptr helics_error): helics_endpoint {.
    cdecl, importc: "helicsFederateGetEndpointByIndex", header: "MessageFederate.h".}
## * set the default destination for an endpoint if no other endpoint is given
##     @param endpoint the endpoint to set the destination for
##     @param dest a string naming the desired default endpoint
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsEndpointSetDefaultDestination*(endpoint: helics_endpoint; dest: cstring;
    err: ptr helics_error) {.cdecl, importc: "helicsEndpointSetDefaultDestination",
                          header: "MessageFederate.h".}
## * get the default destination for an endpoint
##     @param endpoint the endpoint to set the destination for
##     @return a string with the default destination
##

proc helicsEndpointGetDefaultDestination*(endpoint: helics_endpoint): cstring {.
    cdecl, importc: "helicsEndpointGetDefaultDestination",
    header: "MessageFederate.h".}
## * send a message to the specified destination
##     @param endpoint the endpoint to send the data from
##     @param dest the target destination (nullptr to use the default destination)
##     @param data the data to send
##     @param inputDataLength the length of the data to send
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsEndpointSendMessageRaw*(endpoint: helics_endpoint; dest: cstring;
                                  data: pointer; inputDataLength: cint;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSendMessageRaw", header: "MessageFederate.h".}
## * send a message at a specific time to the specified destination
##     @param endpoint the endpoint to send the data from
##     @param dest the target destination (nullptr to use the default destination
##     @param data the data to send
##     @param inputDataLength the length of the data to send
##     @param time the time the message should be sent
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsEndpointSendEventRaw*(endpoint: helics_endpoint; dest: cstring;
                                data: pointer; inputDataLength: cint;
                                time: helics_time; err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSendEventRaw", header: "MessageFederate.h".}
## * send a message object from a specific endpoint
##     @param endpoint the endpoint to send the data from
##     @param message the actual message to send
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsEndpointSendMessage*(endpoint: helics_endpoint;
                               message: ptr helics_message; err: ptr helics_error) {.
    cdecl, importc: "helicsEndpointSendMessage", header: "MessageFederate.h".}
## * send a message object from a specific endpoint
##     @param endpoint the endpoint to send the data from
##     @param message the actual message to send
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsEndpointSendMessageObject*(endpoint: helics_endpoint;
                                     message: helics_message_object;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSendMessageObject", header: "MessageFederate.h".}
## * subscribe an endpoint to a publication
##     @param endpoint the endpoint to use
##     @param key the name of the publication
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching errors
##     @endforcpponly
##

proc helicsEndpointSubscribe*(endpoint: helics_endpoint; key: cstring;
                             err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSubscribe", header: "MessageFederate.h".}
## * check if the federate has any outstanding messages
##     @param fed the federate to check if it has
##     @return helics_true if the federate has a message waiting helics_false otherwise

proc helicsFederateHasMessage*(fed: helics_federate): helics_bool {.cdecl,
    importc: "helicsFederateHasMessage", header: "MessageFederate.h".}
## * check if a given endpoint has any unread messages
##     @param endpoint the endpoint to check
##     @return helics_true if the endpoint has a message, helics_false otherwise

proc helicsEndpointHasMessage*(endpoint: helics_endpoint): helics_bool {.cdecl,
    importc: "helicsEndpointHasMessage", header: "MessageFederate.h".}
## *
##  Returns the number of pending receives for the specified destination endpoint.
##      @param fed the federate to get the number of waiting messages
##

proc helicsFederatePendingMessages*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederatePendingMessages", header: "MessageFederate.h".}
## *
##  Returns the number of pending receives for all endpoints of particular federate.
##      @param endpoint the endpoint to query
##

proc helicsEndpointPendingMessages*(endpoint: helics_endpoint): cint {.cdecl,
    importc: "helicsEndpointPendingMessages", header: "MessageFederate.h".}
## * receive a packet from a particular endpoint
##     @param[in] endpoint the identifier for the endpoint
##     @return a message object

proc helicsEndpointGetMessage*(endpoint: helics_endpoint): helics_message {.cdecl,
    importc: "helicsEndpointGetMessage", header: "MessageFederate.h".}
## * receive a packet from a particular endpoint
##     @param[in] endpoint the identifier for the endpoint
##     @return a message object

proc helicsEndpointGetMessageObject*(endpoint: helics_endpoint): helics_message_object {.
    cdecl, importc: "helicsEndpointGetMessageObject", header: "MessageFederate.h".}
## * receive a communication message for any endpoint in the federate
##     @details the return order will be in order of endpoint creation.
##     So all messages that are available for the first endpoint, then all for the second, and so on
##     within a single endpoint the messages are ordered by time, then source_id, then order of arrival
##     @return a unique_ptr to a Message object containing the message data

proc helicsFederateGetMessage*(fed: helics_federate): helics_message {.cdecl,
    importc: "helicsFederateGetMessage", header: "MessageFederate.h".}
## * receive a communication message for any endpoint in the federate
##      @details the return order will be in order of endpoint creation.
##     So all messages that are available for the first endpoint, then all for the second, and so on
##     within a single endpoint the messages are ordered by time, then source_id, then order of arrival
##     @return a helics_message_object which references the data in the message

proc helicsFederateGetMessageObject*(fed: helics_federate): helics_message_object {.
    cdecl, importc: "helicsFederateGetMessageObject", header: "MessageFederate.h".}
## * create a new empty message object
##     @details, the message is empty and isValid will return false since there is no data associated with the message yet.
##     @return a helics_message_object containing the message data

proc helicsFederateCreateMessageObject*(fed: helics_federate; err: ptr helics_error): helics_message_object {.
    cdecl, importc: "helicsFederateCreateMessageObject",
    header: "MessageFederate.h".}
## * clear all stored messages from a federate
##     @details this clears messages retrieved through helicsFederateGetMessage or helicsFederateGetMessageObject
##     @param fed the federate to clear the message for
##

proc helicsFederateClearMessages*(fed: helics_federate) {.cdecl,
    importc: "helicsFederateClearMessages", header: "MessageFederate.h".}
## * clear all message from an endpoint
##     @param endpoint  the endpoint object to operate on
##

proc helicsEndpointClearMessages*(endpoint: helics_endpoint) {.cdecl,
    importc: "helicsEndpointClearMessages", header: "MessageFederate.h".}
## * get the type specified for an endpoint
##     @param endpoint  the endpoint object in question
##     @return the defined type of the endpoint
##

proc helicsEndpointGetType*(endpoint: helics_endpoint): cstring {.cdecl,
    importc: "helicsEndpointGetType", header: "MessageFederate.h".}
## * get the name of an endpoint
##     @param endpoint  the endpoint object in question
##     @return the name of the endpoint
##

proc helicsEndpointGetName*(endpoint: helics_endpoint): cstring {.cdecl,
    importc: "helicsEndpointGetName", header: "MessageFederate.h".}
## * get the number of endpoints in a federate
##     @param fed the message federate to query
##     @return (-1) if fed was not a valid federate otherwise returns the number of endpoints

proc helicsFederateGetEndpointCount*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederateGetEndpointCount", header: "MessageFederate.h".}
## * get the data in the info field of an filter
##     @param end the filter to query
##     @return a string with the info field string

proc helicsEndpointGetInfo*(`end`: helics_endpoint): cstring {.cdecl,
    importc: "helicsEndpointGetInfo", header: "MessageFederate.h".}
## * set the data in the info field for an filter
##     @param end the endpoint to query
##     @param info the string to set
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsEndpointSetInfo*(`end`: helics_endpoint; info: cstring;
                           err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSetInfo", header: "MessageFederate.h".}
## * set a handle option on an endpoint
##     @param end the endpoint to modify
##     @param option integer code for the option to set /ref helics_handle_options
##     @param value the value to set the option
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsEndpointSetOption*(`end`: helics_endpoint; option: cint;
                             value: helics_bool; err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSetOption", header: "MessageFederate.h".}
## * set a handle option on an endpoint
##     @param end the endpoint to modify
##     @param option integer code for the option to set /ref helics_handle_options
##

proc helicsEndpointGetOption*(`end`: helics_endpoint; option: cint): helics_bool {.
    cdecl, importc: "helicsEndpointGetOption", header: "MessageFederate.h".}
## *
##  \defgroup message operation functions
##     @details functions for working with helics message envelopes
##  @{
##
## * get the source endpoint of a message
##     @param message the message object in question
##     @return a string with the source endpoint
##

proc helicsMessageGetSource*(message: helics_message_object): cstring {.cdecl,
    importc: "helicsMessageGetSource", header: "MessageFederate.h".}
## * get the destination endpoint of a message
##     @param message the message object in question
##     @return a string with the destination endpoint
##

proc helicsMessageGetDestination*(message: helics_message_object): cstring {.cdecl,
    importc: "helicsMessageGetDestination", header: "MessageFederate.h".}
## * get the original source endpoint of a message, the source may have modified by filters or other actions
##     @param message the message object in question
##     @return a string with the source of a message
##

proc helicsMessageGetOriginalSource*(message: helics_message_object): cstring {.
    cdecl, importc: "helicsMessageGetOriginalSource", header: "MessageFederate.h".}
## * get the original destination endpoint of a message, the destination may have been modified by filters or other actions
##     @param message the message object in question
##     @return a string with the original destination of a message
##

proc helicsMessageGetOriginalDestination*(message: helics_message_object): cstring {.
    cdecl, importc: "helicsMessageGetOriginalDestination",
    header: "MessageFederate.h".}
## * get the helics time associated with a message
##     @param message the message object in question
##     @return the time associated with a message
##

proc helicsMessageGetTime*(message: helics_message_object): helics_time {.cdecl,
    importc: "helicsMessageGetTime", header: "MessageFederate.h".}
## * get the payload of a message as a string
##     @param message the message object in question
##     @return a string representing the payload of a message
##

proc helicsMessageGetString*(message: helics_message_object): cstring {.cdecl,
    importc: "helicsMessageGetString", header: "MessageFederate.h".}
## * get the messageID of a message
##     @param message the message object in question
##     @return the messageID
##

proc helicsMessageGetMessageID*(message: helics_message_object): cint {.cdecl,
    importc: "helicsMessageGetMessageID", header: "MessageFederate.h".}
## * check if a flag is set on a message
##     @param message the message object in question
##     @param flag the flag to check should be between [0,15]
##     @return the flags associated with a message
##

proc helicsMessageCheckFlag*(message: helics_message_object; flag: cint): helics_bool {.
    cdecl, importc: "helicsMessageCheckFlag", header: "MessageFederate.h".}
## * get the size of the data payload in bytes
##     @param message the message object in question
##     @return the size of the data payload
##

proc helicsMessageGetRawDataSize*(message: helics_message_object): cint {.cdecl,
    importc: "helicsMessageGetRawDataSize", header: "MessageFederate.h".}
## * get the raw data for a message object
##     @param message a message object to get the data for
##     @param[out] data the memory location of the data
##     @param maxMessagelen the maximum size of information that data can hold
##     @param[out] actualSize  the actual length of data copied to data
##     @forcpponly
##     @param[in,out] err a pointer to an error object for catching erro
##     @endforcpponly
##

proc helicsMessageGetRawData*(message: helics_message_object; data: pointer;
                             maxMessagelen: cint; actualSize: ptr cint;
                             err: ptr helics_error) {.cdecl,
    importc: "helicsMessageGetRawData", header: "MessageFederate.h".}
## * get a pointer to the raw data of a message
##     @param message a message object to get the data for
##     @return a pointer to the raw data in memory, the pointer may be NULL if the message is not a valid message
##

proc helicsMessageGetRawDataPointer*(message: helics_message_object): pointer {.
    cdecl, importc: "helicsMessageGetRawDataPointer", header: "MessageFederate.h".}
## * a check if the message contains a valid payload
##     @param message the message object in question
##     @return true if the message contains a payload
##

proc helicsMessageIsValid*(message: helics_message_object): helics_bool {.cdecl,
    importc: "helicsMessageIsValid", header: "MessageFederate.h".}
## * set the source of a message
##     @param message the message object in question
##     @param src a string containing the source
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetSource*(message: helics_message_object; src: cstring;
                            err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetSource", header: "MessageFederate.h".}
## * set the destination of a message
##     @param message the message object in question
##     @param dest a string containing the new destination
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetDestination*(message: helics_message_object; dest: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetDestination", header: "MessageFederate.h".}
## * set the original source of a message
##     @param message the message object in question
##     @param src a string containing the new original source
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetOriginalSource*(message: helics_message_object; src: cstring;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetOriginalSource", header: "MessageFederate.h".}
## * set the original destination of a message
##     @param message the message object in question
##     @param dest a string containing the new original source
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetOriginalDestination*(message: helics_message_object;
    dest: cstring; err: ptr helics_error) {.cdecl, importc: "helicsMessageSetOriginalDestination",
                                       header: "MessageFederate.h".}
## * set the delivery time for a message
##     @param message the message object in question
##     @param time the time the message should be delivered
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetTime*(message: helics_message_object; time: helics_time;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetTime", header: "MessageFederate.h".}
## * resize the data buffer for a message
##     @details the message data buffer will be resized there is no guarantees on what is in the buffer in newly allocated space
##     if the allocated space is not sufficient new allocations will occur
##     @param message the message object in question
##     @param newSize the new size in bytes of the buffer
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageResize*(message: helics_message_object; newSize: cint;
                         err: ptr helics_error) {.cdecl,
    importc: "helicsMessageResize", header: "MessageFederate.h".}
## * reserve space in a buffer but don't actually resize
##     @details the message data buffer will be reserved but not resized
##     @param message the message object in question
##     @param reserveSize the number of bytes to reserve in the message object
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageReserve*(message: helics_message_object; reserveSize: cint;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsMessageReserve", header: "MessageFederate.h".}
## * set the message ID for the message
##     @details normally this is not needed and the core of HELICS will adjust as needed
##     @param message the message object in question
##     @param messageID a new message ID
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetMessageID*(message: helics_message_object; messageID: int32_t;
                               err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetMessageID", header: "MessageFederate.h".}
## * clear the flags of a message
##     @param message the message object in question

proc helicsMessageClearFlags*(message: helics_message_object) {.cdecl,
    importc: "helicsMessageClearFlags", header: "MessageFederate.h".}
## * set a flag on a message
##     @param message the message object in question
##     @param flag an index of a flag to set on the message
##     @param flagValue the desired value of the flag
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetFlagOption*(message: helics_message_object; flag: cint;
                                flagValue: helics_bool; err: ptr helics_error) {.
    cdecl, importc: "helicsMessageSetFlagOption", header: "MessageFederate.h".}
## * set the data payload of a message as a string
##     @param message the message object in question
##     @param str a string containing the message data
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetString*(message: helics_message_object; str: cstring;
                            err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetString", header: "MessageFederate.h".}
## * set the data payload of a message as raw data
##     @param message the message object in question
##     @param data a string containing the message data
##     @param inputDataLength  the length of the data to input
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageSetData*(message: helics_message_object; data: pointer;
                          inputDataLength: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetData", header: "MessageFederate.h".}
## * append data to the payload
##     @param message the message object in question
##     @param data a string containing the message data to append
##     @param inputDataLength  the length of the data to input
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageAppendData*(message: helics_message_object; data: pointer;
                             inputDataLength: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsMessageAppendData", header: "MessageFederate.h".}
## * copy a message object
##     @param source_message the message object to copy from
##     @param dest_message the message object to copy to
##     @forcpponly
##     @param[in,out] err an error object to fill out in case of an error
##     @endforcpponly
##

proc helicsMessageCopy*(source_message: helics_message_object;
                       dest_message: helics_message_object; err: ptr helics_error) {.
    cdecl, importc: "helicsMessageCopy", header: "MessageFederate.h".}
## *@}
