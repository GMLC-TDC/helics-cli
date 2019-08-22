# -*- coding: utf-8 -*-
import time
import helics as h
import random
import logging
import json

logger = logging.getLogger(__name__)
logger.addHandler(logging.StreamHandler())
logger.setLevel(logging.DEBUG)


def create_federate(name, deltat=1.0, fedinitstring="--federates=1"):

    fedinfo = h.helicsFederateInfoCreate()

    status = h.helicsFederateInfoSetFederateName(fedinfo, name)
    assert status == 0

    status = h.helicsFederateInfoSetCoreTypeFromString(fedinfo, "zmq")
    assert status == 0

    status = h.helicsFederateInfoSetCoreInitString(fedinfo, fedinitstring)
    assert status == 0

    status = h.helicsFederateInfoSetTimeDelta(fedinfo, deltat)
    assert status == 0

    status = h.helicsFederateInfoSetLoggingLevel(fedinfo, 1)
    assert status == 0

    fed = h.helicsCreateCombinationFederate(fedinfo)

    return fed


def destroy_federate(fed, broker):
    status = h.helicsFederateFinalize(fed)

    status, state = h.helicsFederateGetState(fed)
    assert state == 3

    while h.helicsBrokerIsConnected(broker):
        time.sleep(1)

    h.helicsFederateFree(fed)

    h.helicsCloseLibrary()


def main():

    # broker = create_broker()

    with open("{{ config }}") as f:
        data = json.loads(f.read())

    fed = create_federate(data["name"])

    pubids = {}
    for p in data["publications"]:
        pubid = h.helicsFederateRegisterGlobalTypePublication(
            fed, p, h.HELICS_DATA_TYPE_COMPLEX, ""
        )
        pubids[p] = pubid

    subids = {}
    for s in data["subscriptions"]:
        subid = h.helicsFederateRegisterSubscription(fed, s, "complex", "")
        h.helicsSubscriptionSetDefaultComplex(subid, 0, 0)
        subids[s] = subid

    h.helicsFederateEnterExecutionMode(fed)

    hours = 1
    seconds = int(60 * 60 * hours)
    grantedtime = -1
    random.seed(0)
    for t in range(0, seconds, 60 * 5):
        while grantedtime < t:
            status, grantedtime = h.helicsFederateRequestTime(fed, t)

        for p, pubid in pubids.items():
            c = complex(132950, 0) * (1 + (random.random() - 0.5) / 2)
            status = h.helicsPublicationPublishComplex(pubid, c.real, c.imag)
            print(
                "Publishing {} = {} + {}j at time {}".format(
                    p, c.real, c.imag, grantedtime
                ),
                flush=True,
            )

        time.sleep(1)
        for s, subid in subids.items():
            status, rValue, iValue = h.helicsSubscriptionGetComplex(subid)
            print(
                "The value of {} at time {} is {} + {}j".format(
                    s, grantedtime, rValue, iValue
                ),
                flush=True,
            )

    t = 60 * 60 * 24
    while grantedtime < t:
        status, grantedtime = h.helicsFederateRequestTime(fed, t)
    logger.info("Destroying federate")
    destroy_federate(fed)


if __name__ == "__main__":

    main()
    logger.info("Done!")
