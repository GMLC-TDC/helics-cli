# -*- coding: utf-8 -*-
import helics as h
import sys

helicsversion = h.helicsGetVersion()

federate_name = f"Reciever Federate {sys.argv[1]}"

print(f"{federate_name}: Helics version = {h.helicsGetVersion()}")


# Create Federate Info object that describes the federate properties */
print(f"{federate_name}: Creating Federate Info")
fedinfo = h.helicsCreateFederateInfo()

# Set Federate name
print(f"{federate_name}: Setting Federate Info Name")
h.helicsFederateInfoSetCoreName(fedinfo, federate_name)

# Set core type from string
print(f"{federate_name}: Setting Federate Info Core Type")
h.helicsFederateInfoSetCoreTypeFromString(fedinfo, "zmq")

# Federate init string
print(f"{federate_name}: Setting Federate Info Init String")
h.helicsFederateInfoSetCoreInitString(fedinfo, "--federates=1")

# Set the message interval (timedelta) for federate. Note that
# HELICS minimum message time interval is 1 ns and by default
# it uses a time delta of 1 second. What is provided to the
# setTimedelta routine is a multiplier for the default timedelta.

# Set one second message interval
print(f"{federate_name}: Setting Federate Info Time Delta")
h.helicsFederateInfoSetTimeProperty(fedinfo, h.helics_property_time_delta, 0.01)

# Create value federate
print(f"{federate_name}: Creating Value Federate")
vfed = h.helicsCreateValueFederate(federate_name, fedinfo)
print(f"{federate_name}: Value federate created")

# Subscribe to PI SENDER's publication
sub = h.helicsFederateRegisterSubscription(vfed, f"topic{sys.argv[1]}", "")
print(f"{federate_name}: Subscription registered")

h.helicsFederateEnterExecutingMode(vfed)
print(f"{federate_name}: Entering execution mode")

value = 0.0
prevtime = 0

currenttime = -1

while currenttime <= 100:

    currenttime = h.helicsFederateRequestTime(vfed, 100)

    value = h.helicsInputGetString(sub)
    print(
        f"{federate_name}: Received value = {value} at time {currenttime} from PI SENDER"
    )

h.helicsFederateFinalize(vfed)

h.helicsFederateFree(vfed)
h.helicsCloseLibrary()
print(f"{federate_name}: Federate finalized")
