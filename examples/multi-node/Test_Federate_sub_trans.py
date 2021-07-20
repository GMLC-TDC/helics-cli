# -*- coding: utf-8 -*-
import time

import helics as h
import logging
import sys

logger = logging.getLogger(__name__)
logger.addHandler(logging.StreamHandler())
logger.setLevel(logging.DEBUG)


# logger.setLoggingLevel(logging.DEBUG)


def run_sub_trans(fed_name, feeders, broker_address):
    fedinitstring = "--federates=1"
    if broker_address is not None:
        fedinitstring = f"{fedinitstring} --broker_address=tcp://{broker_address}"

    deltat = 0.01

    logger.info(f"{fed_name}: Helics version = {h.helicsGetVersion()}")

    # Create Federate Info object that describes the federate properties #
    fedinfo = h.helicsCreateFederateInfo()

    # Set Federate name #
    h.helicsFederateInfoSetCoreName(fedinfo, fed_name)

    # Set core type from string #
    h.helicsFederateInfoSetCoreTypeFromString(fedinfo, "zmq")

    # Federate init string #
    h.helicsFederateInfoSetCoreInitString(fedinfo, fedinitstring)

    # Set the message interval (timedelta) for federate. Note th#
    # HELICS minimum message time interval is 1 ns and by default
    # it uses a time delta of 1 second. What is provided to the
    # setTimedelta routine is a multiplier for the default timedelta.

    # Set one second message interval #
    h.helicsFederateInfoSetTimeProperty(fedinfo, h.helics_property_time_delta, deltat)

    # Create value federate #
    vfed = h.helicsCreateValueFederate(fed_name, fedinfo)
    logger.info("Value federate created")

    # Register the publication #
    logger.info(f"{fed_name}: Publication registered")

    pubs = []
    subs = []
    for feeder in feeders:
        pub_name = f"{feeder}.voltage"
        logger.info(f"{fed_name}: registering {pub_name}")
        pubs.append(h.helicsFederateRegisterGlobalTypePublication(vfed, pub_name, "double", "pu"))
        logger.info(f"{fed_name}: publication {pub_name} registered")
        sub_name = f"Circuit.{feeder}.TotalPower.E"
        subs.append(h.helicsFederateRegisterSubscription(vfed, sub_name, "kW"))
        logger.info(f"{fed_name}: subscription {sub_name} registered")

    # Enter execution mode
    h.helicsFederateEnterExecutingMode(vfed)
    logger.info(f"{fed_name} Entering executing mode")

    # start execution loop
    n_feeders = len(feeders)
    currenttime = 0
    desiredtime = 0.0
    t = 0.0
    end_time = 24 * 3600
    while desiredtime <= end_time:
        # publish
        desiredtime = t * 15 * 60
        currenttime = h.helicsFederateRequestTime(vfed, desiredtime)
        if currenttime >= desiredtime:
            for p in pubs:
                h.helicsPublicationPublishDouble(p, 1.01)
            for i in range(n_feeders):
                value = h.helicsInputGetDouble(subs[i])
                logger.info(f"Circuit {feeders[i]} active power demand: {value} kW at time: {currenttime}.")
            t += 1

    # all other federates should have finished, so now you can close the broker
    h.helicsFederateFinalize(vfed)
    logger.info(f"{fed_name}: Test Federate finalized")

    h.helicsFederateDestroy(vfed)
    logger.info(f"{fed_name}: test federate destroyed")
    h.helicsFederateFree(vfed)
    logger.info("federate freed")
    h.helicsCloseLibrary()
    logger.info("library closed")


if __name__ == "__main__":
    fed_name = sys.argv[1] if len(sys.argv) >= 2 else "Test_Federate_sub_trans"
    broker_address = sys.argv[2] if len(sys.argv) >= 3 else None
    feeders = ["full_network"]

    run_sub_trans(fed_name, feeders, broker_address)
