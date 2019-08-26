# -*- coding: utf-8 -*-
import opendssdirect as odd
import helics as h

PUBLICATIONS = {}
SUBSCRIPTIONS = {}


def get_value(key):
    print(key)
    return 1.0, 0.0


def set_value(key, value):
    print(key, ": ", value)


def main(filename):
    with open(filename) as f:
        data = json.loads(f.read())

    federate_name = data["name"]
    filename = data["filename"]
    total_time = data["total_time"]
    step_time = data["step_time"]
    subscriptions = data["subscriptions"]
    publications = data["publications"]

    odd.run_command(f"Redirect {filename}")

    fedinfo = h.helicsCreateFederateInfo()

    h.helicsFederateInfoSetCoreName(fedinfo, f"{federate_name}")
    h.helicsFederateInfoSetCoreTypeFromString(fedinfo, "zmq")
    h.helicsFederateInfoSetCoreInitString(fedinfo, fedinitstring)
    h.helicsFederateInfoSetTimeProperty(fedinfo, h.helics_property_time_delta, 1.0)

    fed = h.helicsCreateCombinationFederate(f"federate_name", fedinfo)
    print(f"{federate_name}: Combination federate created")

    for k, v in publications.items():
        pub = h.helicsFederateRegisterPublication(fed, v["total_kW"], "complex", "")
        PUBLICATIONS[k] = pub

    for k, v in subscriptions.items():
        sub = h.helicsFederateRegisterSubscription(
            fed, v["positive_voltage"], "complex", ""
        )
        SUBSCRIPTIONS[k] = sub

    h.helicsFederateEnterExecutingMode(fed)
    print(f"{federate_name}: Entering execution mode")

    this_time = 0.0

    for request_time in range(0, TOTAL_TIME, STEP_TIME):

        h.helicsFederateRequestTime(fed)

        while currenttime < request_time:
            currenttime = h.helicsFederateRequestTime(fed, request_time)

        for key, pub in PUBLICATIONS.items():
            val = get_value(key)
            h.helicsPublicationPublishDouble(pub, val)

        for key, sub in SUBSCRIPTIONS.items():
            val = h.helicsInputGetString(sub)
            set_value(key, val)

    h.helicsFederateFinalize(fed)
    print(f"{federate_name}: Federate finalized")

    while h.helicsBrokerIsConnected(broker):
        time.sleep(1)

    h.helicsFederateFree(fed)
    h.helicsCloseLibrary()

    print(f"{federate_name}: Broker disconnected")


if __name__ == "__main__":

    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("filename", help="json filename that describes OpenDSS feeder")
    args = parser.parse_args()

    main(args.filename)
