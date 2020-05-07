##
## Copyright (c) 2017-2020,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##
## *
##  @file
##  @brief Functions related to message federates for the C api
##

import
  helics

##  MessageFederate Calls
## *
##  Create an endpoint.
##
##  @details The endpoint becomes part of the federate and is destroyed when the federate is freed
##           so there are no separate free functions for endpoints.
##
##  @param fed The federate object in which to create an endpoint must have been created
##            with helicsCreateMessageFederate or helicsCreateCombinationFederate.
##  @param name The identifier for the endpoint. This will be prepended with the federate name for the global identifier.
##  @param type A string describing the expected type of the publication (may be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return An object containing the endpoint.
##  @forcpponly
##          nullptr on failure.
##  @endforcpponly
##

proc helicsFederateRegisterEndpoint*(fed: helics_federate; name: cstring;
                                    `type`: cstring; err: ptr helics_error): helics_endpoint {.
    cdecl, importc: "helicsFederateRegisterEndpoint", dynlib: helicsSharedLib.}
## *
##  Create an endpoint.
##
##  @details The endpoint becomes part of the federate and is destroyed when the federate is freed
##           so there are no separate free functions for endpoints.
##
##  @param fed The federate object in which to create an endpoint must have been created
##               with helicsCreateMessageFederate or helicsCreateCombinationFederate.
##  @param name The identifier for the endpoint, the given name is the global identifier.
##  @param type A string describing the expected type of the publication (may be NULL).
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##  @return An object containing the endpoint.
##  @forcpponly
##          nullptr on failure.
##  @endforcpponly
##

proc helicsFederateRegisterGlobalEndpoint*(fed: helics_federate; name: cstring;
    `type`: cstring; err: ptr helics_error): helics_endpoint {.cdecl,
    importc: "helicsFederateRegisterGlobalEndpoint", dynlib: helicsSharedLib.}
## *
##  Get an endpoint object from a name.
##
##  @param fed The message federate object to use to get the endpoint.
##  @param name The name of the endpoint.
##  @forcpponly
##  @param[in,out] err The error object to complete if there is an error.
##  @endforcpponly
##
##  @return A helics_endpoint object.
##  @forcpponly
##          The object will not be valid and err will contain an error code if no endpoint with the specified name exists.
##  @endforcpponly
##

proc helicsFederateGetEndpoint*(fed: helics_federate; name: cstring;
                               err: ptr helics_error): helics_endpoint {.cdecl,
    importc: "helicsFederateGetEndpoint", dynlib: helicsSharedLib.}
## *
##  Get an endpoint by its index, typically already created via registerInterfaces file or something of that nature.
##
##  @param fed The federate object in which to create a publication.
##  @param index The index of the publication to get.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @return A helics_endpoint.
##  @forcpponly
##          It will be NULL if given an invalid index.
##  @endforcpponly
##

proc helicsFederateGetEndpointByIndex*(fed: helics_federate; index: cint;
                                      err: ptr helics_error): helics_endpoint {.
    cdecl, importc: "helicsFederateGetEndpointByIndex", dynlib: helicsSharedLib.}
## *
##  Check if an endpoint is valid.
##
##  @param endpoint The endpoint object to check.
##
##  @return helics_true if the Endpoint object represents a valid endpoint.
##

proc helicsEndpointIsValid*(endpoint: helics_endpoint): helics_bool {.cdecl,
    importc: "helicsEndpointIsValid", dynlib: helicsSharedLib.}
## *
##  Set the default destination for an endpoint if no other endpoint is given.
##
##  @param endpoint The endpoint to set the destination for.
##  @param dest A string naming the desired default endpoint.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsEndpointSetDefaultDestination*(endpoint: helics_endpoint; dest: cstring;
    err: ptr helics_error) {.cdecl, importc: "helicsEndpointSetDefaultDestination",
                          dynlib: helicsSharedLib.}
## *
##  Get the default destination for an endpoint.
##
##  @param endpoint The endpoint to set the destination for.
##
##  @return A string with the default destination.
##

proc helicsEndpointGetDefaultDestination*(endpoint: helics_endpoint): cstring {.
    cdecl, importc: "helicsEndpointGetDefaultDestination", dynlib: helicsSharedLib.}
## *
##  Send a message to the specified destination.
##
##  @param endpoint The endpoint to send the data from.
##  @param dest The target destination.
##  @forcpponly
##              nullptr to use the default destination.
##  @endforcpponly
##  @beginpythononly
##              "" to use the default destination.
##  @endpythononly
##  @param data The data to send.
##  @forcpponly
##  @param inputDataLength The length of the data to send.
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsEndpointSendMessageRaw*(endpoint: helics_endpoint; dest: cstring;
                                  data: pointer; inputDataLength: cint;
                                  err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSendMessageRaw", dynlib: helicsSharedLib.}
## *
##  Send a message at a specific time to the specified destination.
##
##  @param endpoint The endpoint to send the data from.
##  @param dest The target destination.
##  @forcpponly
##              nullptr to use the default destination.
##  @endforcpponly
##  @beginpythononly
##              "" to use the default destination.
##  @endpythononly
##  @param data The data to send.
##  @forcpponly
##  @param inputDataLength The length of the data to send.
##  @endforcpponly
##  @param time The time the message should be sent.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsEndpointSendEventRaw*(endpoint: helics_endpoint; dest: cstring;
                                data: pointer; inputDataLength: cint;
                                time: helics_time; err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSendEventRaw", dynlib: helicsSharedLib.}
## *
##  Send a message object from a specific endpoint.
##  @deprecated Use helicsEndpointSendMessageObject instead.
##  @param endpoint The endpoint to send the data from.
##  @param message The actual message to send.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsEndpointSendMessage*(endpoint: helics_endpoint;
                               message: ptr helics_message; err: ptr helics_error) {.
    cdecl, importc: "helicsEndpointSendMessage", dynlib: helicsSharedLib.}
## *
##  Send a message object from a specific endpoint.
##
##  @param endpoint The endpoint to send the data from.
##  @param message The actual message to send which will be copied.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsEndpointSendMessageObject*(endpoint: helics_endpoint;
                                     message: helics_message_object;
                                     err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSendMessageObject", dynlib: helicsSharedLib.}
## *
##  Send a message object from a specific endpoint, the message will not be copied and the message object will no longer be valid
##  after the call.
##
##  @param endpoint The endpoint to send the data from.
##  @param message The actual message to send which will be copied.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsEndpointSendMessageObjectZeroCopy*(endpoint: helics_endpoint;
    message: helics_message_object; err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSendMessageObjectZeroCopy", dynlib: helicsSharedLib.}
## *
##  Subscribe an endpoint to a publication.
##
##  @param endpoint The endpoint to use.
##  @param key The name of the publication.
##  @forcpponly
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##

proc helicsEndpointSubscribe*(endpoint: helics_endpoint; key: cstring;
                             err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSubscribe", dynlib: helicsSharedLib.}
## *
##  Check if the federate has any outstanding messages.
##
##  @param fed The federate to check.
##
##  @return helics_true if the federate has a message waiting, helics_false otherwise.
##

proc helicsFederateHasMessage*(fed: helics_federate): helics_bool {.cdecl,
    importc: "helicsFederateHasMessage", dynlib: helicsSharedLib.}
## *
##  Check if a given endpoint has any unread messages.
##
##  @param endpoint The endpoint to check.
##
##  @return helics_true if the endpoint has a message, helics_false otherwise.
##

proc helicsEndpointHasMessage*(endpoint: helics_endpoint): helics_bool {.cdecl,
    importc: "helicsEndpointHasMessage", dynlib: helicsSharedLib.}
## *
##  Returns the number of pending receives for the specified destination endpoint.
##
##  @param fed The federate to get the number of waiting messages from.
##

proc helicsFederatePendingMessages*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederatePendingMessages", dynlib: helicsSharedLib.}
## *
##  Returns the number of pending receives for all endpoints of a particular federate.
##
##  @param endpoint The endpoint to query.
##

proc helicsEndpointPendingMessages*(endpoint: helics_endpoint): cint {.cdecl,
    importc: "helicsEndpointPendingMessages", dynlib: helicsSharedLib.}
## *
##  Receive a packet from a particular endpoint.
##
##  @deprecated This function is deprecated and will be removed in Helics 3.0.
##              Use helicsEndpointGetMessageObject instead.
##
##  @param[in] endpoint The identifier for the endpoint.
##
##  @return A message object.
##

proc helicsEndpointGetMessage*(endpoint: helics_endpoint): helics_message {.cdecl,
    importc: "helicsEndpointGetMessage", dynlib: helicsSharedLib.}
## *
##  Receive a packet from a particular endpoint.
##
##  @param[in] endpoint The identifier for the endpoint.
##
##  @return A message object.
##

proc helicsEndpointGetMessageObject*(endpoint: helics_endpoint): helics_message_object {.
    cdecl, importc: "helicsEndpointGetMessageObject", dynlib: helicsSharedLib.}
## *
##  Receive a communication message for any endpoint in the federate.
##
##  @deprecated This function is deprecated and will be removed in Helics 3.0.
##              Use helicsFederateGetMessageObject instead.
##
##  @details The return order will be in order of endpoint creation.
##           So all messages that are available for the first endpoint, then all for the second, and so on.
##           Within a single endpoint, the messages are ordered by time, then source_id, then order of arrival.
##
##  @return A unique_ptr to a Message object containing the message data.
##

proc helicsFederateGetMessage*(fed: helics_federate): helics_message {.cdecl,
    importc: "helicsFederateGetMessage", dynlib: helicsSharedLib.}
## *
##  Receive a communication message for any endpoint in the federate.
##
##  @details The return order will be in order of endpoint creation.
##           So all messages that are available for the first endpoint, then all for the second, and so on.
##           Within a single endpoint, the messages are ordered by time, then source_id, then order of arrival.
##
##  @return A helics_message_object which references the data in the message.
##

proc helicsFederateGetMessageObject*(fed: helics_federate): helics_message_object {.
    cdecl, importc: "helicsFederateGetMessageObject", dynlib: helicsSharedLib.}
## *
##  Create a new empty message object.
##
##  @details The message is empty and isValid will return false since there is no data associated with the message yet.
##
##  @return A helics_message_object containing the message data.
##

proc helicsFederateCreateMessageObject*(fed: helics_federate; err: ptr helics_error): helics_message_object {.
    cdecl, importc: "helicsFederateCreateMessageObject", dynlib: helicsSharedLib.}
## *
##  Clear all stored messages from a federate.
##
##  @details This clears messages retrieved through helicsFederateGetMessage or helicsFederateGetMessageObject
##
##  @param fed The federate to clear the message for.
##

proc helicsFederateClearMessages*(fed: helics_federate) {.cdecl,
    importc: "helicsFederateClearMessages", dynlib: helicsSharedLib.}
## *
##  Clear all message from an endpoint.
##
##  @deprecated This function does nothing and will be removed.
##              Use helicsFederateClearMessages to free all messages,
##              or helicsMessageFree to clear an individual message.
##
##  @param endpoint The endpoint object to operate on.
##

proc helicsEndpointClearMessages*(endpoint: helics_endpoint) {.cdecl,
    importc: "helicsEndpointClearMessages", dynlib: helicsSharedLib.}
## *
##  Get the type specified for an endpoint.
##
##  @param endpoint The endpoint object in question.
##
##  @return The defined type of the endpoint.
##

proc helicsEndpointGetType*(endpoint: helics_endpoint): cstring {.cdecl,
    importc: "helicsEndpointGetType", dynlib: helicsSharedLib.}
## *
##  Get the name of an endpoint.
##
##  @param endpoint The endpoint object in question.
##
##  @return The name of the endpoint.
##

proc helicsEndpointGetName*(endpoint: helics_endpoint): cstring {.cdecl,
    importc: "helicsEndpointGetName", dynlib: helicsSharedLib.}
## *
##  Get the number of endpoints in a federate.
##
##  @param fed The message federate to query.
##
##  @return (-1) if fed was not a valid federate, otherwise returns the number of endpoints.
##

proc helicsFederateGetEndpointCount*(fed: helics_federate): cint {.cdecl,
    importc: "helicsFederateGetEndpointCount", dynlib: helicsSharedLib.}
## *
##  Get the data in the info field of a filter.
##
##  @param end The filter to query.
##
##  @return A string with the info field string.
##

proc helicsEndpointGetInfo*(`end`: helics_endpoint): cstring {.cdecl,
    importc: "helicsEndpointGetInfo", dynlib: helicsSharedLib.}
## *
##  Set the data in the info field for a filter.
##
##  @param end The endpoint to query.
##  @param info The string to set.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsEndpointSetInfo*(`end`: helics_endpoint; info: cstring;
                           err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSetInfo", dynlib: helicsSharedLib.}
## *
##  Set a handle option on an endpoint.
##
##  @param end The endpoint to modify.
##  @param option Integer code for the option to set /ref helics_handle_options.
##  @param value The value to set the option to.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsEndpointSetOption*(`end`: helics_endpoint; option: cint;
                             value: helics_bool; err: ptr helics_error) {.cdecl,
    importc: "helicsEndpointSetOption", dynlib: helicsSharedLib.}
## *
##  Set a handle option on an endpoint.
##
##  @param end The endpoint to modify.
##  @param option Integer code for the option to set /ref helics_handle_options.
##

proc helicsEndpointGetOption*(`end`: helics_endpoint; option: cint): helics_bool {.
    cdecl, importc: "helicsEndpointGetOption", dynlib: helicsSharedLib.}
## *
##  \defgroup Message operation functions
##  @details Functions for working with helics message envelopes.
##  @{
##
## *
##  Get the source endpoint of a message.
##
##  @param message The message object in question.
##
##  @return A string with the source endpoint.
##

proc helicsMessageGetSource*(message: helics_message_object): cstring {.cdecl,
    importc: "helicsMessageGetSource", dynlib: helicsSharedLib.}
## *
##  Get the destination endpoint of a message.
##
##  @param message The message object in question.
##
##  @return A string with the destination endpoint.
##

proc helicsMessageGetDestination*(message: helics_message_object): cstring {.cdecl,
    importc: "helicsMessageGetDestination", dynlib: helicsSharedLib.}
## *
##  Get the original source endpoint of a message, the source may have been modified by filters or other actions.
##
##  @param message The message object in question.
##
##  @return A string with the source of a message.
##

proc helicsMessageGetOriginalSource*(message: helics_message_object): cstring {.
    cdecl, importc: "helicsMessageGetOriginalSource", dynlib: helicsSharedLib.}
## *
##  Get the original destination endpoint of a message, the destination may have been modified by filters or other actions.
##
##  @param message The message object in question.
##
##  @return A string with the original destination of a message.
##

proc helicsMessageGetOriginalDestination*(message: helics_message_object): cstring {.
    cdecl, importc: "helicsMessageGetOriginalDestination", dynlib: helicsSharedLib.}
## *
##  Get the helics time associated with a message.
##
##  @param message The message object in question.
##
##  @return The time associated with a message.
##

proc helicsMessageGetTime*(message: helics_message_object): helics_time {.cdecl,
    importc: "helicsMessageGetTime", dynlib: helicsSharedLib.}
## *
##  Get the payload of a message as a string.
##
##  @param message The message object in question.
##
##  @return A string representing the payload of a message.
##

proc helicsMessageGetString*(message: helics_message_object): cstring {.cdecl,
    importc: "helicsMessageGetString", dynlib: helicsSharedLib.}
## *
##  Get the messageID of a message.
##
##  @param message The message object in question.
##
##  @return The messageID.
##

proc helicsMessageGetMessageID*(message: helics_message_object): cint {.cdecl,
    importc: "helicsMessageGetMessageID", dynlib: helicsSharedLib.}
## *
##  Check if a flag is set on a message.
##
##  @param message The message object in question.
##  @param flag The flag to check should be between [0,15].
##
##  @return The flags associated with a message.
##

proc helicsMessageCheckFlag*(message: helics_message_object; flag: cint): helics_bool {.
    cdecl, importc: "helicsMessageCheckFlag", dynlib: helicsSharedLib.}
## *
##  Get the size of the data payload in bytes.
##
##  @param message The message object in question.
##
##  @return The size of the data payload.
##

proc helicsMessageGetRawDataSize*(message: helics_message_object): cint {.cdecl,
    importc: "helicsMessageGetRawDataSize", dynlib: helicsSharedLib.}
## *
##  Get the raw data for a message object.
##
##  @param message A message object to get the data for.
##  @forcpponly
##  @param[out] data The memory location of the data.
##  @param maxMessagelen The maximum size of information that data can hold.
##  @param[out] actualSize The actual length of data copied to data.
##  @param[in,out] err A pointer to an error object for catching errors.
##  @endforcpponly
##
##  @beginPythonOnly
##  @return Raw string data.
##  @endPythonOnly
##

proc helicsMessageGetRawData*(message: helics_message_object; data: pointer;
                             maxMessagelen: cint; actualSize: ptr cint;
                             err: ptr helics_error) {.cdecl,
    importc: "helicsMessageGetRawData", dynlib: helicsSharedLib.}
## *
##  Get a pointer to the raw data of a message.
##
##  @param message A message object to get the data for.
##
##  @return A pointer to the raw data in memory, the pointer may be NULL if the message is not a valid message.
##

proc helicsMessageGetRawDataPointer*(message: helics_message_object): pointer {.
    cdecl, importc: "helicsMessageGetRawDataPointer", dynlib: helicsSharedLib.}
## *
##  A check if the message contains a valid payload.
##
##  @param message The message object in question.
##
##  @return helics_true if the message contains a payload.
##

proc helicsMessageIsValid*(message: helics_message_object): helics_bool {.cdecl,
    importc: "helicsMessageIsValid", dynlib: helicsSharedLib.}
## *
##  Set the source of a message.
##
##  @param message The message object in question.
##  @param src A string containing the source.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetSource*(message: helics_message_object; src: cstring;
                            err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetSource", dynlib: helicsSharedLib.}
## *
##  Set the destination of a message.
##
##  @param message The message object in question.
##  @param dest A string containing the new destination.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetDestination*(message: helics_message_object; dest: cstring;
                                 err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetDestination", dynlib: helicsSharedLib.}
## *
##  Set the original source of a message.
##
##  @param message The message object in question.
##  @param src A string containing the new original source.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetOriginalSource*(message: helics_message_object; src: cstring;
                                    err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetOriginalSource", dynlib: helicsSharedLib.}
## *
##  Set the original destination of a message.
##
##  @param message The message object in question.
##  @param dest A string containing the new original source.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetOriginalDestination*(message: helics_message_object;
    dest: cstring; err: ptr helics_error) {.cdecl, importc: "helicsMessageSetOriginalDestination",
                                       dynlib: helicsSharedLib.}
## *
##  Set the delivery time for a message.
##
##  @param message The message object in question.
##  @param time The time the message should be delivered.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetTime*(message: helics_message_object; time: helics_time;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetTime", dynlib: helicsSharedLib.}
## *
##  Resize the data buffer for a message.
##
##  @details The message data buffer will be resized. There are no guarantees on what is in the buffer in newly allocated space.
##           If the allocated space is not sufficient new allocations will occur.
##
##  @param message The message object in question.
##  @param newSize The new size in bytes of the buffer.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageResize*(message: helics_message_object; newSize: cint;
                         err: ptr helics_error) {.cdecl,
    importc: "helicsMessageResize", dynlib: helicsSharedLib.}
## *
##  Reserve space in a buffer but don't actually resize.
##
##  @details The message data buffer will be reserved but not resized.
##
##  @param message The message object in question.
##  @param reserveSize The number of bytes to reserve in the message object.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageReserve*(message: helics_message_object; reserveSize: cint;
                          err: ptr helics_error) {.cdecl,
    importc: "helicsMessageReserve", dynlib: helicsSharedLib.}
## *
##  Set the message ID for the message.
##
##  @details Normally this is not needed and the core of HELICS will adjust as needed.
##
##  @param message The message object in question.
##  @param messageID A new message ID.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetMessageID*(message: helics_message_object; messageID: int32_t;
                               err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetMessageID", dynlib: helicsSharedLib.}
## *
##  Clear the flags of a message.
##
##  @param message The message object in question
##

proc helicsMessageClearFlags*(message: helics_message_object) {.cdecl,
    importc: "helicsMessageClearFlags", dynlib: helicsSharedLib.}
## *
##  Set a flag on a message.
##
##  @param message The message object in question.
##  @param flag An index of a flag to set on the message.
##  @param flagValue The desired value of the flag.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetFlagOption*(message: helics_message_object; flag: cint;
                                flagValue: helics_bool; err: ptr helics_error) {.
    cdecl, importc: "helicsMessageSetFlagOption", dynlib: helicsSharedLib.}
## *
##  Set the data payload of a message as a string.
##
##  @param message The message object in question.
##  @param str A string containing the message data.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetString*(message: helics_message_object; str: cstring;
                            err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetString", dynlib: helicsSharedLib.}
## *
##  Set the data payload of a message as raw data.
##
##  @param message The message object in question.
##  @param data A string containing the message data.
##  @param inputDataLength The length of the data to input.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageSetData*(message: helics_message_object; data: pointer;
                          inputDataLength: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsMessageSetData", dynlib: helicsSharedLib.}
## *
##  Append data to the payload.
##
##  @param message The message object in question.
##  @param data A string containing the message data to append.
##  @param inputDataLength The length of the data to input.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageAppendData*(message: helics_message_object; data: pointer;
                             inputDataLength: cint; err: ptr helics_error) {.cdecl,
    importc: "helicsMessageAppendData", dynlib: helicsSharedLib.}
## *
##  Copy a message object.
##
##  @param source_message The message object to copy from.
##  @param dest_message The message object to copy to.
##  @forcpponly
##  @param[in,out] err An error object to fill out in case of an error.
##  @endforcpponly
##

proc helicsMessageCopy*(source_message: helics_message_object;
                       dest_message: helics_message_object; err: ptr helics_error) {.
    cdecl, importc: "helicsMessageCopy", dynlib: helicsSharedLib.}
## *@}
