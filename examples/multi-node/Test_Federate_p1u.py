# -*- coding: utf-8 -*-
import helics as h
import logging
import sys

logger = logging.getLogger(__name__)
logger.addHandler(logging.StreamHandler())
logger.setLevel(logging.DEBUG)


# logger.setLoggingLevel(logging.DEBUG)


def pub_and_sub_calc(supply_voltage, last_loads, sub_loads, pub_voltages):
    # calculate the voltage fed to feeders below
    feeder_voltage = [
        supply_voltage * 0.999 - max((fl - 1000) / 100, 0) for fl in last_loads
    ]
    n_feeders = len(last_loads)
    new_loads = [0.0 for _ in range(0, n_feeders)]
    load_diff = [0.0 for _ in range(0, n_feeders)]
    # publish feeder supply voltages
    for i in range(0, n_feeders):
        h.helicsPublicationPublishDouble(pub_voltages[i], feeder_voltage[i])

    # subscribe to all feeder loads and check for convergence
    for i in range(0, n_feeders):
        new_loads[i] = h.helicsInputGetDouble(sub_loads[i])
        logger.debug(
            f"Circuit {feeders[i]} active power demand: {new_loads[i]} at voltage: {feeder_voltage[i]}"
        )
        load_diff[i] = abs(last_loads[i] - new_loads[i])
    logger.debug(f"total load difference: {load_diff}")

    return new_loads


def run_p1u_federate(fed_name, broker_address, feeders):
    fedinitstring = "--federates=1"
    if broker_address is not None:
        fedinitstring = f"{fedinitstring} --broker_address=tcp://{broker_address}"

    deltat = 0.01

    print(f"{fed_name}: Helics version = {h.helicsGetVersion()}")

    # Create Federate Info object that describes the federate properties
    fedinfo = h.helicsCreateFederateInfo()

    # Set Federate name
    h.helicsFederateInfoSetCoreName(fedinfo, fed_name)

    # Set core type from string
    h.helicsFederateInfoSetCoreTypeFromString(fedinfo, "zmq")

    # Federate init string
    h.helicsFederateInfoSetCoreInitString(fedinfo, fedinitstring)

    # Set one second message interval
    h.helicsFederateInfoSetTimeProperty(fedinfo, h.helics_property_time_delta, deltat)

    # Create value federate
    vfed = h.helicsCreateValueFederate(fed_name, fedinfo)
    print("Value federate created")

    # Register the publications
    pub_load = h.helicsFederateRegisterGlobalTypePublication(
        vfed, "Circuit.full_network.TotalPower.E", "double", "kW"
    )
    pub_voltages = []
    for feeder in feeders:
        pub_name = f"Circuit.feeder_p1u.{feeder}.p1ux.voltage"
        pub_voltages.append(
            h.helicsFederateRegisterGlobalTypePublication(
                vfed, pub_name, "double", "pu"
            )
        )
        print(f"{fed_name}: publication {pub_name} registered")

    # Register subscriptions
    # subscribe to voltage supplied
    sub_voltage = h.helicsFederateRegisterSubscription(
        vfed, "full_network.voltage", "pu"
    )
    h.helicsInputSetDefaultDouble(sub_voltage, 1.0)
    # subscribe to loads below
    sub_loads = []
    for feeder in feeders:
        sub_name = f"Circuit.feeder_p1u.{feeder}.p1ux.TotalPower.E"
        sub_loads.append(h.helicsFederateRegisterSubscription(vfed, sub_name, "kW"))
        print(f"{fed_name}: subscription {sub_name} registered")

    h.helicsFederateSetIntegerProperty(vfed, h.helics_property_int_max_iterations, 10)
    # Enter execution mode
    h.helicsFederateEnterExecutingMode(vfed)
    print(f"{fed_name} Entering executing mode")

    # start execution loop
    n_feeders = len(feeders)
    desiredtime = 0.0
    t = 0.0
    end_time = 24 * 3600
    while desiredtime <= end_time:
        # check time
        desiredtime = t * 15 * 60
        currenttime = h.helicsFederateRequestTime(vfed, desiredtime)
        if currenttime >= desiredtime:
            last_loads = [0 for i in range(0, n_feeders)]
            # reiterate between supply voltage and loads for up to __ iterations
            # get supply voltage
            iters = 1
            supply_voltage = h.helicsInputGetDouble(sub_voltage)
            iteration_state = h.helics_iteration_result_iterating

            while iteration_state == h.helics_iteration_result_iterating:
                # if there is an iteration going on, publish and subscribe again
                new_loads = pub_and_sub_calc(
                    supply_voltage, last_loads, sub_loads, pub_voltages
                )
                currenttime, iteration_state = h.helicsFederateRequestTimeIterative(
                    vfed, desiredtime, h.helics_iteration_request_iterate_if_needed
                )
                # find change in load and determine if you need to continue iterating
                load_diff = 0
                for i in range(n_feeders):
                    load_diff = load_diff + abs(new_loads[i] - last_loads[i])
                if load_diff / n_feeders < 1e-3:
                    iteration_state = 0
                last_loads = new_loads
                iters += 1

            h.helicsPublicationPublishDouble(pub_load, sum(last_loads))
            logger.info(
                f"feeder loads {last_loads} at time {currenttime} after {iters} iters"
            )
            t += 1

    # all other federates should have finished, so now you can close
    h.helicsFederateFinalize(vfed)
    print(f"{fed_name}: Test Federate finalized")

    h.helicsFederateDestroy(vfed)
    print(f"{fed_name}: test federate destroyed")
    h.helicsFederateFree(vfed)
    print(f"{fed_name}: federate freed")
    h.helicsCloseLibrary()
    print(f"{fed_name}: library closed")


if __name__ == "__main__":
    fed_name = sys.argv[1] if len(sys.argv) >= 2 else "Test_Federate_p1u"
    broker_address = sys.argv[2] if len(sys.argv) >= 3 else None
    feeders = sys.argv[3:] if len(sys.argv) >= 4 else ["p1uhs0"]

    run_p1u_federate(fed_name, broker_address, feeders)
