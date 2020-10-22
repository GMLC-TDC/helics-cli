# -*- coding: utf-8 -*-
import json
import logging
import time

import helics as h

from .database import initialize_database, MetaData


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
    fedinfo.flag[h.HELICS_FLAG_TERMINATE_ON_ERROR] = True

    # fedinfo.flag[h.HELICS_HANDLE_OPTION_STRICT_TYPE_CHECKING] = True

    h.helicsFederateInfoSetFlagOption(fedinfo, h.HELICS_HANDLE_OPTION_STRICT_TYPE_CHECKING, True)

    fed = h.helicsCreateCombinationFederate(core_name, fedinfo)
    return fed


def write_database_data(db, fed: h.HelicsFederate, subscriptions=[]):

    print("Making query ...")
    federates = fed.query("root", "federates").replace("[", "").replace("]", "").split(";")

    for name in federates:
        print(f"Query for exists: {name}")

        if fed.query(name, "state") == "disconnected":
            continue

        print(f"Query for current_time: {name}")
        data = fed.query(name, "current_time")
        try:
            data = json.loads(data)
            granted_time = data["granted_time"]
            requested_time = data["requested_time"]
            if data["allow"] > 9223372036:
                break
        except Exception:
            granted_time = 0.0
            requested_time = 0.0

        db.execute("INSERT INTO Federates(name, granted, requested) VALUES (?,?,?);", (name, granted_time, requested_time))

        if fed.query(name, "state") == "disconnected":
            continue
        print(f"Query for publications: {name}")
        publications = fed.query(name, "publications").replace("[", "").replace("]", "").split(";")

        for pub_str in publications:
            subs = [s for s in subscriptions if s.key == pub_str]
            if len(subs) > 1:
                print("ERROR: multiple subscriptions to same publication.")
            elif len(pub_str) > 0 and len(subs) == 1:
                db.execute("UPDATE Publications SET new_value=0;")
                db.execute(
                    "INSERT INTO Publications(key, sender, pub_time, pub_value, new_value) VALUES (?,?,?,?,?);",
                    (pub_str, name, granted_time, subs[0].string, 1),
                )

    db.commit()


def run(n_federates: int):
    try:
        _run(n_federates)
    except h.HelicsException:
        h.helicsCloseLibrary()
        return 1
    finally:
        h.helicsCloseLibrary()
    return 0


def _run(n_federates: int):
    print("Loading HELICS Library")

    print("Initializing database")
    db = initialize_database("helics-cli.db")
    metadata = MetaData(db)

    metadata["version"] = h.helicsGetVersion()
    metadata["n_federates"] = n_federates

    print("Creating broker")
    broker = h.helicsCreateBroker("zmq", "", f"-f{n_federates + 1} --loglevel=7")

    print("Creating observer federate")

    fed = init_combination_federate("__observer__")

    print("Entering initializing mode")

    # TODO: replace with time barrier

    time.sleep(5)

    federates = fed.query("root", "federates").replace("[", "").replace("]", "").split(";")
    federates = [name for name in federates if name != "__observer__"]

    print("federates: ", federates)

    while not all(fed.query(name, "isinit") == "true" for name in federates if name != "__observer__"):
        print(f"Waiting for all federates ({federates}) to join ...")
        print(all(fed.query(name, "isinit") == "true" for name in federates))
        time.sleep(1)

    # Assuming all federates have connected.

    print("Querying all topics")

    metadata["federates"] = ",".join([f for f in federates if not f.startswith("__")])

    publications = fed.query("root", "publications").replace("[", "").replace("]", "").split(";")
    subscriptions = []
    for pub in publications:
        subscriptions.append(fed.register_subscription(pub))

    fed.enter_initializing_mode()

    fed.enter_executing_mode()

    print("entered executing mode")
    brokers = fed.query("root", "brokers")
    print(brokers)

    current_time = 0.0
    while True:
        print(f"Current time is {current_time}")
        current_time = fed.request_next_step()
        print(f"Granted time {current_time}, calling DB Write")
        write_database_data(db, fed, subscriptions)
        print("State ...")
        if all(fed.query(name, "state") == "disconnected" for name in federates if name != "__observer__") or current_time >= 9223372036.3:
            break

    print("Finished observe.")
    print("Closing database ...")
    db.close()

    print("Finalizing federate ...")
    fed.finalize()
    print("Deleting federate ...")
    del fed

    print("Broker disconnect ...")
    broker.disconnect()
    print("Waiting for broker to disconnect ...")
    broker.wait_for_disconnect()

    print("Closing helics library ...")
    h.helicsCloseLibrary()

    return 0
