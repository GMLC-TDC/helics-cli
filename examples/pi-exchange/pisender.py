# -*- coding: utf-8 -*-
import time
import sys

from math import pi
import helics as h
import random

federate_name = f"SenderFederate{sys.argv[1]}"

print(f"{federate_name}: Helics version = {h.helicsGetVersion()}")

fedinfo = h.helicsCreateFederateInfo()

h.helicsFederateInfoSetCoreName(fedinfo, federate_name + "Core")
h.helicsFederateInfoSetCoreTypeFromString(fedinfo, "zmq")
h.helicsFederateInfoSetCoreInitString(fedinfo, "--federates=1")
h.helicsFederateInfoSetTimeProperty(fedinfo, h.helics_property_time_delta, 0.01)

vfed = h.helicsCreateValueFederate(federate_name, fedinfo)

print(f"{federate_name}: Value federate created")

pub = h.helicsFederateRegisterGlobalTypePublication(vfed, f"globaltopic{sys.argv[1]}", "double", "")

print(f"{federate_name}: Publication registered")

h.helicsFederateEnterExecutingMode(vfed)
print(f"{federate_name}: Entering execution mode")

this_time = 0.0
value = pi

for t in range(0, 10):
    val = value

    currenttime = h.helicsFederateRequestTime(vfed, t)

    h.helicsPublicationPublishDouble(pub, val)
    print(f"{federate_name}: Sending value pi = {val} at time {currenttime}")

    # Computing user needs
    time.sleep(float(sys.argv[1]) * (1 + (0.5 - random.random()) / 10))

h.helicsFederateFinalize(vfed)
print(f"{federate_name}: Federate finalized")

h.helicsFederateFree(vfed)
h.helicsCloseLibrary()
