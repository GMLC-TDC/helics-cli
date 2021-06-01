# -*- coding: utf-8 -*-
import asyncio
import json
import logging
import os
import time

import helics as h

from .utils.message_handler import MessageHandler, SimpleMessage
from .database import initialize_database, MetaData

logger = logging.getLogger(__name__)

OBSERVER_BROKER: h.HelicsBroker = None
OBSERVER_FEDERATE: h.HelicsCombinationFederate = None
SERVER_MESSAGE_HANDLER: MessageHandler = None
time_control = {"nonstop": True, "requested_time": 0.0, "exited": False}


def init_combination_federate(
    core_name,
    nfederates=1,
    core_type="zmq",
    core_init="",
    broker_init="",
    time_delta=1.0,
    log_level=7,
    strict_type_checking=True,
    terminate_on_error=True,
):
    core_init = f"{core_init} --federates={nfederates}"

    fedinfo = h.helicsCreateFederateInfo()
    fedinfo.core_name = f"{core_name}Core"
    fedinfo.core_type = core_type
    fedinfo.core_init = core_init
    fedinfo.broker_init = broker_init
    fedinfo.property[h.HELICS_PROPERTY_TIME_DELTA] = time_delta
    fedinfo.property[h.HELICS_PROPERTY_TIME_PERIOD] = time_delta
    fedinfo.flag[h.HELICS_FLAG_TERMINATE_ON_ERROR] = True

    # fedinfo.flag[h.HELICS_HANDLE_OPTION_STRICT_TYPE_CHECKING] = True

    h.helicsFederateInfoSetFlagOption(fedinfo, h.HELICS_HANDLE_OPTION_STRICT_TYPE_CHECKING, True)
    global OBSERVER_FEDERATE
    OBSERVER_FEDERATE = h.helicsCreateCombinationFederate(core_name, fedinfo)


def write_database_data(db, federate: h.HelicsFederate, subscriptions=[], current_time=0.0):
    logger.debug("Making query ...")

    federates = [name for name in federate.query("root", "federates") if name != "__observer__"]

    for name in federates:
        logger.debug(f"Query for exists: {name}")

        if federate.query(name, "state") == "disconnected":
            continue

        logger.debug(f"Query for current_time: {name}")
        data = federate.query(name, "current_time")
        logger.debug(f"data is: {data}")
        try:
            granted_time = data["granted_time"]
            requested_time = data["requested_time"]
            if data["allow"] > 9223372036:
                break
        except Exception as ex:
            logger.warning(f"current time query threw {ex}")
            granted_time = current_time
            requested_time = float("NaN")

        db.execute("INSERT INTO Federates(name, granted, requested) VALUES (?,?,?);", (name, granted_time, requested_time))

        if federate.query(name, "state") == "disconnected":
            continue
        logger.debug(f"Query for publications: {name}")
        publications = federate.query(name, "publications")  # .replace("[", "").replace("]", "").split(";")
        logger.debug(f"{name} publishes: {publications}")

        for pub_str in publications:
            logger.debug(f"pub_str: {pub_str}")
            subs = [s for s in subscriptions if s.target == pub_str]
            logger.debug(f"subs info: {subs}")
            if len(subs) > 1:
                logger.info("ERROR: multiple subscriptions to same publication.")
            elif len(pub_str) > 0 and len(subs) == 1:
                db.execute("UPDATE Publications SET new_value=0;")
                publication_type = subs[0].publication_type
                if publication_type == "double":
                    value = subs[0].double
                elif publication_type == "integer":
                    value = subs[0].integer
                else:
                    value = subs[0].string

                logger.info(f"Publication value is {value} of type {type}")
                db.execute(
                    "INSERT INTO Publications(key, sender, pub_time, pub_value, new_value) VALUES (?,?,?,?,?);",
                    (pub_str, name, granted_time, value, 1),
                )

    db.commit()


def process_message(message: SimpleMessage):
    logger.info(f"processing message {message}")
    if message.Type == "QUERY":
        logger.debug("Processing query")
        query_target = json.loads(message.Message)
        logger.debug(f"Query target was: {query_target}")
        query_response = OBSERVER_FEDERATE.query(query_target["target"], query_target["query"])
        logger.debug(f"Query response was: {query_response}")
        return SimpleMessage("QUERY_RESPONSE", query_response)
    elif message.Type == "SIGNAL":
        signal_data = json.loads(message.Message)
        logger.info("Processing signal")
        if signal_data["operation"] == "FASTFORWARD":
            logger.info("got FF")
            time_control["requested_time"] = 9223372036.3
            time_control["nonstop"] = True
            time_control["exited"] = True
            h.helicsBrokerClearTimeBarrier(OBSERVER_BROKER)
            return SimpleMessage("SIGNAL_RESPONSE", "{}")
        if signal_data["operation"] == "STOP":
            logger.info("got STOP")
            time_control["exited"] = True
            OBSERVER_FEDERATE.finalize()  # TODO: see if this is the right way to exit.
            h.helicsBrokerDisconnect(OBSERVER_BROKER)
            # h.helicsBrokerClearTimeBarrier(OBSERVER_BROKER)
            return SimpleMessage("SIGNAL_RESPONSE", "{}")
        if signal_data["operation"] == "RUNTO":
            time_control["requested_time"] = signal_data["target_time"]
            # h.helicsBrokerClearTimeBarrier(OBSERVER_BROKER)
            h.helicsBrokerSetTimeBarrier(OBSERVER_BROKER, signal_data["target_time"])
            logger.info("got RUNTO")
        return SimpleMessage("SIGNAL_RESPONSE", "{}")
    else:
        logger.info("Unknown message type received")
        return SimpleMessage("ERROR_RESPONSE", "{}")


def check_first_message():
    if SERVER_MESSAGE_HANDLER.Enabled:
        logger.info("Processing pre-start messages from server")
        while True:
            message = SERVER_MESSAGE_HANDLER.get_server()
            logger.debug(f"Received message {message}")
            response = process_message(message)
            SERVER_MESSAGE_HANDLER.send_server(response)
            if SERVER_MESSAGE_HANDLER.ToHelics.empty() and time_control["requested_time"] > 0.0 or time_control["nonstop"]:
                break


def ingest_messages():
    if SERVER_MESSAGE_HANDLER.Enabled:
        logger.info("Processing messages from server")
        while not SERVER_MESSAGE_HANDLER.ToHelics.empty():  # action event was new message
            message = SERVER_MESSAGE_HANDLER.get_server()
            logger.debug(f"Received message {message}")
            response = process_message(message)
            SERVER_MESSAGE_HANDLER.send_server(response)


def run(n_federates: int, config_path: str, log_level: int, message_handler: MessageHandler = None):

    file_out = logging.FileHandler("observer.log", mode="w")
    file_out.setLevel(logging.DEBUG)
    stream_out = logging.StreamHandler()
    stream_out.setLevel(logging.ERROR)
    logger.addHandler(file_out)
    logger.addHandler(stream_out)

    global SERVER_MESSAGE_HANDLER
    SERVER_MESSAGE_HANDLER = message_handler
    if SERVER_MESSAGE_HANDLER.Enabled:
        time_control["nonstop"] = False

    try:
        asyncio.run(_run(n_federates, config_path, log_level))
    except KeyboardInterrupt:
        logger.info("User canceled operation")
    except h.HelicsException:
        logger.error("Failed and threw HelicsException")
        h.helicsCloseLibrary()
        return 1
    finally:
        logger.debug("In finally")
        h.helicsCloseLibrary()
    return 0


async def _run(n_federates: int, config_path: str, log_level: int = 2):
    path_to_config = os.path.abspath(config_path)
    path = os.path.dirname(path_to_config)

    with open(path_to_config) as f:
        config = json.loads(f.read())
    logger.info("Read config: %s", config["broker"]["observer"])

    logger.info("Loading HELICS Library")

    logger.info("Initializing database")
    db = initialize_database(path + "/helics-cli.db", logger, do_init=True)
    metadata = MetaData(db)

    metadata["version"] = h.helicsGetVersion()
    metadata["n_federates"] = n_federates

    logger.info("Creating broker")
    global OBSERVER_BROKER
    OBSERVER_BROKER = h.helicsCreateBroker("zmq", "", f"-f{n_federates + 1} --loglevel={log_level}")

    logger.info("Creating observer federate")

    init_combination_federate("__observer__")

    logger.info("Entering initializing mode")

    # if not time_control["nonstop"]:
    #     h.helicsBrokerSetTimeBarrier(broker, 0.0)
    # else:
    time.sleep(2)

    federates = OBSERVER_FEDERATE.query("root", "federates")  # .replace("[", "").replace("]", "").split(";")
    federates = [name for name in federates if name != "__observer__"]

    logger.info(f"federates: {federates}")

    while not all(OBSERVER_FEDERATE.query(name, "isinit") is True for name in federates if name != "__observer__"):
        logger.info(f"Waiting for all federates ({federates}) to join ...")
        logger.info(all(OBSERVER_FEDERATE.query(name, "isinit") is True for name in federates))
        for name in federates:
            logger.info(f"{name} isinit = {OBSERVER_FEDERATE.query(name, 'isinit')}")
        time.sleep(1)

    # Assuming all federates have connected.

    logger.info("Querying all topics")

    metadata["federates"] = ",".join([f for f in federates if not f.startswith("__")])

    publications = OBSERVER_FEDERATE.query("root", "publications")  # .replace("[", "").replace("]", "").split(";")
    subscriptions = []
    # TODO: improve subscription filtering to be a bit more friendly
    for pub in publications:
        if "include" in config["broker"]["observer"].keys() and pub not in config["broker"]["observer"]["include"]:
            continue
        else:
            subscriptions.append(OBSERVER_FEDERATE.register_subscription(pub))
    # TODO: message clones

    h.helicsBrokerSetTimeBarrier(OBSERVER_BROKER, 0.0)

    try:
        logger.info("calling exec")

        check_first_message()

        OBSERVER_FEDERATE.enter_executing_mode()
        logger.info("called exec")

        logger.info("entered executing mode")
        brokers = OBSERVER_FEDERATE.query("root", "brokers")
        logger.info(brokers)

        current_time = 0.0
        get_next_step = True
        while True:
            if get_next_step:
                OBSERVER_FEDERATE.request_time_async(0.0)
                get_next_step = False

            if OBSERVER_FEDERATE.is_async_operation_completed() or not SERVER_MESSAGE_HANDLER.ToHelics.empty():
                if not SERVER_MESSAGE_HANDLER.ToHelics.empty():
                    ingest_messages()
                elif OBSERVER_FEDERATE.is_async_operation_completed():
                    current_time = OBSERVER_FEDERATE.request_time_complete()
                    logger.debug(f"Granted time {current_time}, calling DB Write")
                    write_database_data(db, OBSERVER_FEDERATE, subscriptions, current_time)
                    get_next_step = True
                    continue
            else:
                await asyncio.sleep(0.001)  # There's probably a better way to do this, but this is the solution for now.
                # time.sleep(1)  # There's probably a better way to do this, but this is the solution for now.
            # if not time_control["exited"]:
            #     ingest_messages(current_time)

            if not time_control["nonstop"] or current_time >= 9223372036.3:
                continue
            if (
                all(OBSERVER_FEDERATE.query(name, "state") == "disconnected" for name in federates if name != "__observer__")
                or current_time >= 9223372036.3
            ):
                break

        logger.info("Finished observe.")
        logger.info("finalizing monitoring task")
        # message_handler.cancel()
        # try:
        #     await message_handler
        # except asyncio.CancelledError:
        #     logger.info("Monitor shutdown")
        logger.info("Closing database ...")
        db.close()

    except KeyboardInterrupt:
        logger.debug("Observer got keyboard interrupt")
        raise
    finally:
        logger.debug("Observer finalizing")
        logger.info("Finalizing federate ...")
        OBSERVER_FEDERATE.finalize()
        logger.info("Deleting federate ...")

        logger.info("Broker disconnect ...")
        OBSERVER_BROKER.disconnect()
        logger.info("Waiting for broker to disconnect ...")
        OBSERVER_BROKER.wait_for_disconnect()

        logger.info("Closing helics library ...")
        h.helicsCloseLibrary()

    return 0
