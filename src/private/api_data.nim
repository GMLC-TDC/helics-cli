##
## Copyright (c) 2017-2020,
## Battelle Memorial Institute; Lawrence Livermore National Security, LLC; Alliance for Sustainable Energy, LLC.  See the top-level NOTICE for
## additional details. All rights reserved.
## SPDX-License-Identifier: BSD-3-Clause
##

## * @file
## @brief data structures for the C-API
##

import helics_enums

## * opaque object representing an input

type
  helics_input* = pointer

## * opaque object representing a publication

type
  helics_publication* = pointer

## * opaque object representing an endpoint

type
  helics_endpoint* = pointer

## * opaque object representing a filter

type
  helics_filter* = pointer

## * opaque object representing a core

type
  helics_core* = pointer

## * opaque object representing a broker

type
  helics_broker* = pointer

## * opaque object representing a federate

type
  helics_federate* = pointer

## * opaque object representing a filter info object structure

type
  helics_federate_info* = pointer

## * opaque object representing a query

type
  helics_query* = pointer

## * opaque object representing a message

type
  helics_message_object* = pointer

## * time definition used in the C interface to helics

type
  helics_time* = cdouble

var helics_time_zero* {.importc: "helics_time_zero", header: "api-data.h".}: helics_time

## !< definition of time zero-the beginning of simulation

var helics_time_epsilon* {.importc: "helics_time_epsilon", header: "api-data.h".}: helics_time

## !< definition of the minimum time resolution

var helics_time_invalid* {.importc: "helics_time_invalid", header: "api-data.h".}: helics_time

## !< definition of an invalid time that has no meaning

var helics_time_maxtime* {.importc: "helics_time_maxtime", header: "api-data.h".}: helics_time

## !< definition of time signifying the federate has terminated or to run until the end of the simulation
## * defining a boolean type for use in the helics interface

type
  helics_bool* = cint

var helics_true* {.importc: "helics_true", header: "api-data.h".}: helics_bool

## !< indicator used for a true response

var helics_false* {.importc: "helics_false", header: "api-data.h".}: helics_bool

## !< indicator used for a false response
## * enumeration of the different iteration results

type
  helics_iteration_request* {.size: sizeof(cint).} = enum
    helics_iteration_request_no_iteration, ## !< no iteration is requested
    helics_iteration_request_force_iteration, ## !< force iteration return when able
    helics_iteration_request_iterate_if_needed ## !< only return an iteration if necessary


## * enumeration of possible return values from an iterative time request

type
  helics_iteration_result* {.size: sizeof(cint).} = enum
    helics_iteration_result_next_step, ## !< the iterations have progressed to the next time
    helics_iteration_result_error, ## !< there was an error
    helics_iteration_result_halted, ## !< the federation has halted
    helics_iteration_result_iterating ## !< the federate is iterating at current time


## * enumeration of possible federate states

type
  helics_federate_state* {.size: sizeof(cint).} = enum
    helics_state_startup = 0,   ## !< when created the federate is in startup state
    helics_state_initialization, ## !< entered after the enterInitializingMode call has returned
    helics_state_execution,   ## !< entered after the enterExectuationState call has returned
    helics_state_finalize,    ## !< the federate has finished executing normally final values may be retrieved
    helics_state_error, ## !< error state no core communication is possible but values can be retrieved
                       ##  the following states are for asynchronous operations
    helics_state_pending_init, ## !< indicator that the federate is pending entry to initialization state
    helics_state_pending_exec, ## !< state pending EnterExecution State
    helics_state_pending_time, ## !< state that the federate is pending a timeRequest
    helics_state_pending_iterative_time, ## !< state that the federate is pending an iterative time request
    helics_state_pending_finalize ## !< state that the federate is pending a finalize request


## *
##   structure defining a basic complex type
##

type
  helics_complex* {.importc: "helics_complex", header: "api-data.h", bycopy.} = object
    real* {.importc: "real".}: cdouble
    imag* {.importc: "imag".}: cdouble


## *
##   Message_t mapped to a c compatible structure
##  @details this will be deprecated in HELICS 2.3 and removed in HELICS 3.0
##

type
  helics_message* {.importc: "helics_message", header: "api-data.h", bycopy.} = object
    time* {.importc: "time".}: helics_time ## !< message time
    data* {.importc: "data".}: cstring ## !< message data
    length* {.importc: "length".}: int64 ## !< message length
    messageID* {.importc: "messageID".}: int32 ## !< message identification information
    flags* {.importc: "flags".}: int16 ## !< flags related to the message
    original_source* {.importc: "original_source".}: cstring ## !< original source
    source* {.importc: "source".}: cstring ## !< the most recent source
    dest* {.importc: "dest".}: cstring ## !< the final destination
    original_dest* {.importc: "original_dest".}: cstring ## !< the original destination of the message


## *
##  helics error object
##
##  if error_code==0 there is no error, if error_code!=0 there is an error and message will contain a string
##     otherwise it will be an empty string
##

type
  helics_error* {.importc: "helics_error", header: "api-data.h", bycopy.} = object
    message* {.importc: "message".}: cstring ## !< a message associated with the error
