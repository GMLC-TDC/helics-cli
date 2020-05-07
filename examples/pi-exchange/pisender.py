# -*- coding: utf-8 -*-
import time
import helics as h
import sys
from math import pi

federate_name = f"Sender Federate {sys.argv[1]}"

print(f"{federate_name}: Helics version = {h.helicsGetVersion()}")

# Create Federate Info object that describes the federate properties #
fedinfo = h.helicsCreateFederateInfo()

# Set Federate name #
h.helicsFederateInfoSetCoreName(fedinfo, federate_name)

# Set core type from string #
h.helicsFederateInfoSetCoreTypeFromString(fedinfo, "zmq")

# Federate init string #
h.helicsFederateInfoSetCoreInitString(fedinfo, "--federates=1")

# Set the message interval (timedelta) for federate. Note th#
# HELICS minimum message time interval is 1 ns and by default
# it uses a time delta of 1 second. What is provided to the
# setTimedelta routine is a multiplier for the default timedelta.

# Set one second message interval #
h.helicsFederateInfoSetTimeProperty(fedinfo, h.helics_property_time_delta, 0.01)

# Create value federate #
vfed = h.helicsCreateValueFederate(federate_name, fedinfo)
print(f"{federate_name}: Value federate created")

# Register the publication #
pub = h.helicsFederateRegisterGlobalTypePublication(
    vfed, f"topic{sys.argv[1]}", "double", ""
)
print(f"{federate_name}: Publication registered")

# Enter execution mode #
h.helicsFederateEnterExecutingMode(vfed)
print(f"{federate_name}: Entering execution mode")

# This federate will be publishing deltat*pi for numsteps steps #
this_time = 0.0
value = pi

for t in range(5, 10):
    val = value

    currenttime = h.helicsFederateRequestTime(vfed, t)

    h.helicsPublicationPublishDouble(pub, val)
    print(f"{federate_name}: Sending value pi = {val} at time {currenttime}")

    time.sleep(1)

h.helicsFederateFinalize(vfed)
print(f"{federate_name}: Federate finalized")

h.helicsFederateFree(vfed)
h.helicsCloseLibrary()
