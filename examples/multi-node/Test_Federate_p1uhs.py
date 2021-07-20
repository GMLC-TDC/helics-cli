# -*- coding: utf-8 -*-
import helics as h
import logging
import sys

logger = logging.getLogger(__name__)
logger.addHandler(logging.StreamHandler())
logger.setLevel(logging.DEBUG)
# logger.setLoggingLevel(logging.DEBUG)


def pub_and_sub_calc(sub_voltage, pub_load, iters):
    # get the supply voltage
    supply_voltage = h.helicsInputGetDouble(sub_voltage)
    # print("reiteration {} with supply voltage {}".format(iters, supply_voltage))
    logging.debug(f"reiteration {iters} with supply voltage {supply_voltage}")

    # calculate load based on supply voltage
    feeder_load = 1000 + supply_voltage / iters

    # publish feeder load
    h.helicsPublicationPublishDouble(pub_load, feeder_load)
    return supply_voltage, feeder_load


def run_p1uhs_federate(fed_name, broker_address=None):
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
    vfed = h.helicsCreateCombinationFederate(fed_name, fedinfo)
    print("Value federate created")

    # Register global endpoint
    h.helicsFederateRegisterGlobalEndpoint(vfed, "p1uhs_global_status", "string")

    # Register the publications #
    pub_name = f"Circuit.feeder_p1u.{fed_name}.p1ux.TotalPower.E"
    pub_load = h.helicsFederateRegisterGlobalTypePublication(vfed, pub_name, "double", "kW")
    print(f"{fed_name}: publication {pub_name} registered")

    # Register subscriptions #
    # subscribe to voltage supplied
    sub_name = f"Circuit.feeder_p1u.{fed_name}.p1ux.voltage"
    sub_voltage = h.helicsFederateRegisterSubscription(vfed, sub_name, "pu")
    # subscribe to reiteration flag
    # sub_flag = h.helicsFederateRegisterSubscription(vfed, "reiterate_flag", None)
    # h.helicsFederateSetIntegerProperty(vfed, h.helics_property_int_max_iterations, 10)

    # Enter execution mode #
    h.helicsFederateEnterExecutingMode(vfed)
    # fed_iteration_state = h.helicsFederateEnterExecutingModeIterative(vfed, h.helics_iteration_request_iterate_if_needed)
    print(f"{fed_name}: Entering execution mode")

    # start execution loop #
    desiredtime = 0.0
    t = 0.0
    end_time = 24 * 3600  # 95*15*60
    while desiredtime <= end_time:
        # check time
        desiredtime = t * 15 * 60
        currenttime = h.helicsFederateRequestTime(vfed, desiredtime)
        if currenttime >= desiredtime:
            # reiterate until convergence
            last_voltage = 1.0
            iters = 1
            iteration_state = h.helics_iteration_result_iterating

            while iteration_state == h.helics_iteration_result_iterating:
                supply_voltage, load = pub_and_sub_calc(sub_voltage, pub_load, iters)
                currenttime, iteration_state = h.helicsFederateRequestTimeIterative(vfed, desiredtime, h.helics_iteration_request_iterate_if_needed)
                if abs(last_voltage - supply_voltage) < 1e-20:
                    iteration_state = -1
                iters += 1
                last_voltage = supply_voltage

            logging.info("p1uhs0 load {} with voltage {} at time {} after {} iters".format(load, supply_voltage, currenttime, iters))
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
    fed_name = sys.argv[1] if len(sys.argv) >= 2 else "p1uhs0"
    broker_address = sys.argv[2] if len(sys.argv) >= 3 else None
    run_p1uhs_federate(fed_name, broker_address)
