# -*- coding: utf-8 -*-
import opendssdirect as odd
import helics as h
import json

PUBLICATIONS = {}
SUBSCRIPTIONS = {}


def get_value(pub):
    class_name = pub["element_type"]
    element_name = pub["element_name"]
    fn = pub["value"]
    fold = pub.get("fold", "sum")

    odd.Circuit.SetActiveClass(class_name)
    odd.Circuit.SetActiveElement(element_name)

    assert (
        odd.CktElement.Name().lower() == f"{class_name}.{element_name}".lower()
    ), f"Got {odd.CktElement.Name()} but expected {class_name}.{element_name}"

    v = getattr(odd.CktElement, fn)()
    v = v[0 : int(round(len(v) / 2))]
    if fold == "sum":
        v = (sum(v[0 : len(v) : 2]), sum(v[1 : len(v) : 2]))
    elif fold == "avg":
        v = (
            sum(v[0 : len(v) : 2]) / (len(v) / 2),
            sum(v[1 : len(v) : 2]) / (len(v) / 2),
        )
    elif fold == "list":
        # return list
        pass
    else:
        raise NotImplementedError(f"Unknown fold type: {fold}")

    return v


def set_value(sub, value):
    class_name = sub["element_type"]
    element_name = sub["element_name"]
    fn = sub["value"]

    odd.Circuit.SetActiveClass(class_name)
    odd.Circuit.SetActiveElement(element_name)

    assert (
        odd.CktElement.Name().lower() == f"{class_name}.{element_name}".lower()
    ), f"Got {odd.CktElement.Name()} but expected {class_name}.{element_name}"

    if class_name == "Vsource" and element_name == "source":
        odd.Vsources.PU(value[0])
        odd.Vsources.AngleDeg(value[1])
    else:
        getattr(odd.CktElement, fn)(value)


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
    h.helicsFederateInfoSetCoreInitString(fedinfo, "--federates=1")
    h.helicsFederateInfoSetTimeProperty(fedinfo, h.helics_property_time_delta, 1.0)

    fed = h.helicsCreateCombinationFederate(f"{federate_name}", fedinfo)
    print(f"{federate_name}: Combination federate created")

    for k, v in publications.items():
        pub = h.helicsFederateRegisterTypePublication(fed, v["topic"], "complex", "")
        PUBLICATIONS[k] = pub

    for k, v in subscriptions.items():
        sub = h.helicsFederateRegisterSubscription(fed, v["topic"], "")
        SUBSCRIPTIONS[k] = sub

    h.helicsFederateEnterExecutingMode(fed)
    print(f"{federate_name}: Entering execution mode")

    currenttime = 0.0

    for request_time in range(0, total_time, step_time):

        while currenttime < request_time:
            currenttime = h.helicsFederateRequestTime(fed, request_time)

        odd.run_command(f"Solve t={currenttime}")

        for key, pub in PUBLICATIONS.items():
            val = get_value(publications[key])
            print(f"Sending {val} at time {currenttime}")
            typ = "complex"
            if typ == "complex":
                h.helicsPublicationPublishComplex(pub, val[0], val[1])
            else:
                raise NotImplementedError(f"Unknown type of data {typ}")

        for key, sub in SUBSCRIPTIONS.items():
            val = h.helicsInputGetComplex(sub)
            print(f"Received {val} at time {currenttime}")
            set_value(subscriptions[key], val)

    h.helicsFederateFinalize(fed)
    print(f"{federate_name}: Federate finalized")

    h.helicsFederateFree(fed)
    h.helicsCloseLibrary()


if __name__ == "__main__":

    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("filename", help="json filename that describes OpenDSS feeder")
    args = parser.parse_args()

    main(args.filename)
