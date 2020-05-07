# -*- coding: utf-8 -*-
import sys
import helics as h

helicsversion = h.helicsGetVersion()

federate_name = f"Reciever Federate {sys.argv[1]}"

print(f"{federate_name}: Helics version = {h.helicsGetVersion()}")


print(f"{federate_name}: Creating Federate Info")
fedinfo = h.helicsCreateFederateInfo()

print(f"{federate_name}: Setting Federate Info Name")
h.helicsFederateInfoSetCoreName(fedinfo, federate_name)

print(f"{federate_name}: Setting Federate Info Core Type")
h.helicsFederateInfoSetCoreTypeFromString(fedinfo, "zmq")

print(f"{federate_name}: Setting Federate Info Init String")
h.helicsFederateInfoSetCoreInitString(fedinfo, "--federates=1")

print(f"{federate_name}: Setting Federate Info Time Delta")
h.helicsFederateInfoSetTimeProperty(fedinfo, h.helics_property_time_delta, 0.01)

print(f"{federate_name}: Creating Value Federate")
vfed = h.helicsCreateValueFederate(federate_name, fedinfo)
print(f"{federate_name}: Value federate created")

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
    print(f"{federate_name}: Received value = {value} at time {currenttime}")

h.helicsFederateFinalize(vfed)

h.helicsFederateFree(vfed)
h.helicsCloseLibrary()
print(f"{federate_name}: Federate finalized")
