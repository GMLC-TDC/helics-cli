# -*- coding: utf-8 -*-

import helics as h
import logging
import sys

logger = logging.getLogger(__name__)
logger.addHandler(logging.StreamHandler())
logger.setLoggingLevel(logging.DEBUG)


def run_sub_trans(feeders, broker_address):
    fedinitstring = "--federates=1"
    if broker_address is not None:
        fedinitstring = f"{fedinitstring} --broker_address=tcp://{broker_address}"

    deltat = 0.01

    print(f"{fed_name}: Helics version = {h.helicsGetVersion()}")

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
    print("Value federate created")

    # Register the publication #
    print(f"{fed_name}: Publication registered")

    pubs = []
    subs = []
    for feeder in feeders:
        pub_name = f"{feeder}.voltage"
        pubs.append(
            h.helicsFederateRegisterGlobalTypePublication(
                vfed, pub_name, "double", "pu"
            )
        )
        print(f"{fed_name}: publication {pub_name} registered")
        sub_name = "Circuit.{feeder}.TotalPower.E"
        subs.append(h.helicsFederateRegisterSubscription(vfed, sub_name, "kW"))
        print(f"{fed_name}: subscription {sub_name} registered")

    # Enter execution mode
    h.helicsFederateEnterExecutingMode(vfed)
    print(f"{fed_name} Entering executing mode")

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
                print(
                    f"Circuit {feeders[i]} active power demand: {value} kW at time: {currenttime}."
                )
            t += 1

    # all other federates should have finished, so now you can close the broker
    h.helicsFederateFinalize(vfed)
    print(f"{fed_name}: Test Federate finalized")

    h.helicsFederateDestroy(vfed)
    print(f"{fed_name}: test federate destroyed")
    h.helicsFederateFree(vfed)
    print("federate freed")
    h.helicsCloseLibrary()
    print("library closed")


if __name__ == "__main__":

    fed_name = sys.argv[1]
    broker_address = None

    if len(sys.argv) > 1:
        broker_address = sys.argv[2]

    run_sub_trans(fed_name, broker_address)
