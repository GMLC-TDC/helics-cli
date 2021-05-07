# -*- coding: utf-8 -*-
import asyncio
import json
import logging
import os
import time
from decimal import Decimal

import helics as h

from helics_cli.SupportClasses.MessageHandler import MessageHandler, SimpleMessage
from .database import initialize_database, MetaData

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
file_out = logging.FileHandler("observer.log", mode='w')
file_out.setLevel(logging.DEBUG)
stream_out = logging.StreamHandler()
stream_out.setLevel(logging.ERROR)
logger.addHandler(file_out)
logger.addHandler(stream_out)

broker: h.HelicsBroker
fed: h.HelicsCombinationFederate
server_message_handler: MessageHandler
time_control = {
    'nonstop': True,
    'requested_time': 0.0,
    'exited': False
}


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

    fed = h.helicsCreateCombinationFederate(core_name, fedinfo)
    return fed


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

        db.execute("INSERT INTO Federates(name, granted, requested) VALUES (?,?,?);",
                   (name, granted_time, requested_time))

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
    global fed
    logger.info(f"processing message {message}")
    if message.Type == "QUERY":
        logger.debug("Processing query")
        query_target = json.loads(message.Message)
        logger.debug(f"Query target was: {query_target}")
        query_response = fed.query(query_target["target"], query_target["query"])
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
            h.helicsBrokerClearTimeBarrier(broker)
            return SimpleMessage("SIGNAL_RESPONSE", "{}")
        if signal_data["operation"] == "STOP":
            logger.info("got STOP")
            time_control["exited"] = True
            fed.finalize()  # TODO: see if this is the right way to exit.
            h.helicsBrokerDisconnect(broker)
            # h.helicsBrokerClearTimeBarrier(broker)
            return SimpleMessage("SIGNAL_RESPONSE", "{}")
        if signal_data["operation"] == "RUNTO":
            time_control["requested_time"] = signal_data["target_time"]
            # h.helicsBrokerClearTimeBarrier(broker)
            h.helicsBrokerSetTimeBarrier(broker, signal_data["target_time"])
            logger.info("got RUNTO")
        return SimpleMessage("SIGNAL_RESPONSE", "{}")
    else:
        logger.info("Unknown message type received")
        return SimpleMessage("ERROR_RESPONSE", "{}")


def check_first_message():
    if server_message_handler.Enabled:
        logger.info("Processing pre-start messages from server")
        while True:
            message = server_message_handler.get_server()
            logger.debug(f"Received message {message}")
            response = process_message(message)
            server_message_handler.send_server(response)
            if server_message_handler.ToHelics.empty() and time_control["requested_time"] > 0.0 or \
                    time_control["nonstop"]:
                break


def ingest_messages():
    if server_message_handler.Enabled:
        logger.info(f"Processing messages from server")
        while not server_message_handler.ToHelics.empty():  # action event was new message
            message = server_message_handler.get_server()
            logger.debug(f"Received message {message}")
            response = process_message(message)
            server_message_handler.send_server(response)


def run(n_federates: int, config_path: str, log_level: int, message_handler: MessageHandler = None):
    global server_message_handler
    server_message_handler = message_handler
    if server_message_handler.Enabled:
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
    global fed
    global server_message_handler
    global broker

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
    broker = h.helicsCreateBroker("zmq", "", f"-f{n_federates + 1} --loglevel={log_level}")

    logger.info("Creating observer federate")

    fed = init_combination_federate("__observer__")

    logger.info("Entering initializing mode")

    # if not time_control["nonstop"]:
    #     h.helicsBrokerSetTimeBarrier(broker, 0.0)
    # else:
    time.sleep(2)

    federates = fed.query("root", "federates")  # .replace("[", "").replace("]", "").split(";")
    federates = [name for name in federates if name != "__observer__"]

    logger.info(f"federates: {federates}")

    while not all(fed.query(name, "isinit") is True for name in federates if name != "__observer__"):
        logger.info(f"Waiting for all federates ({federates}) to join ...")
        logger.info(all(fed.query(name, "isinit") is True for name in federates))
        for name in federates:
            logger.info(f"{name} isinit = {fed.query(name, 'isinit')}")
        time.sleep(1)

    # Assuming all federates have connected.

    logger.info("Querying all topics")

    metadata["federates"] = ",".join([f for f in federates if not f.startswith("__")])

    publications = fed.query("root", "publications")  # .replace("[", "").replace("]", "").split(";")
    subscriptions = []
    # TODO: improve subscription filtering to be a bit more friendly
    for pub in publications:
        if "include" in config["broker"]["observer"].keys() and pub not in config["broker"]["observer"]["include"]:
            continue
        else:
            subscriptions.append(fed.register_subscription(pub))
    # TODO: message clones

    h.helicsBrokerSetTimeBarrier(broker, 0.0)

    try:
        logger.info("calling exec")

        check_first_message()

        fed.enter_executing_mode()
        logger.info("called exec")

        logger.info("entered executing mode")
        brokers = fed.query("root", "brokers")
        logger.info(brokers)

        current_time = 0.0
        get_next_step = True
        while True:
            if get_next_step:
                fed.request_time_async(0.0)
                get_next_step = False

            if fed.is_async_operation_completed() or not server_message_handler.ToHelics.empty():
                if not server_message_handler.ToHelics.empty():
                    ingest_messages()
                elif fed.is_async_operation_completed():
                    current_time = fed.request_time_complete()
                    logger.debug(f"Granted time {current_time}, calling DB Write")
                    write_database_data(db, fed, subscriptions, current_time)
                    get_next_step = True
                    continue
            else:
                await asyncio.sleep(
                    0.001)  # There's probably a better way to do this, but this is the solution for now.
                # time.sleep(1)  # There's probably a better way to do this, but this is the solution for now.
            # if not time_control["exited"]:
            #     ingest_messages(current_time)

            if not time_control["nonstop"] or current_time >= 9223372036.3:
                continue
            if all(fed.query(name, "state") == "disconnected" for name in federates if
                   name != "__observer__") or current_time >= 9223372036.3:
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
        fed.finalize()
        logger.info("Deleting federate ...")
        del fed

        logger.info("Broker disconnect ...")
        broker.disconnect()
        logger.info("Waiting for broker to disconnect ...")
        broker.wait_for_disconnect()

        logger.info("Closing helics library ...")
        h.helicsCloseLibrary()
    return 0
