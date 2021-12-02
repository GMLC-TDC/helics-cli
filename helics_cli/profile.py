# -*- coding: utf-8 -*-

import os
import re

import matplotlib.pyplot as plt
import matplotlib.patches as patches

CURRENT_DIR = os.path.realpath(os.path.basename(__file__))

# <PROFILING>SenderFederate2[131074](initializing)HELICS CODE ENTRY<4570827706580384>[t=-1000000]</PROFILING>
PATTERN = re.compile(
    r"""
            (?P<name>\w+)                           # SenderFederate2
            \[(\d+)\]                               # [131074]
            \((?P<state>\w+)\)                      # (initializing)
            (?P<message>(?:\w|\s)+)                 # HELICS CODE ENTRY
            \<(?P<realtime>\d+(?:\|\d+)?)\>          # <4570827706580384>
            \[t=(?P<simtime>-?\d*\.{0,1}\d+)\]      # [t=-1000000]
            """,
    re.X,
)


def profile(filename):
    with open(filename) as f:
        data = f.read()
    data = data.replace(r"<PROFILING>", "").replace(r"</PROFILING>", "")
    names = []
    states = []
    messages = []
    simtimes = []
    realtimes = []
    for line in data.splitlines():
        m = PATTERN.match(line)
        name = m.group("name")
        state = m.group("state")
        message = m.group("message")
        simtime = float(m.group("simtime"))
        try:
            realtime = float(m.group("realtime"))
            names.append(name)
            states.append(state)
            messages.append(message)
            simtimes.append(simtime)
            realtimes.append(realtime)
        except:
            pass

    profile = {}
    for name in set(names):
        profile[name] = []

    for (name, state, message, simtime, realtime) in zip(names, states, messages, simtimes, realtimes):
        if state == "created":
            continue
        if "ENTRY" in message:
            profile[name].append({"s_enter": simtime, "r_enter": realtime})
        if "EXIT" in message:
            profile[name][-1]["s_end"] = simtime
            profile[name][-1]["r_end"] = realtime

    return profile


def plot(profile, kind="simulation"):
    profiles = []
    names = {k: i for i, k in enumerate(profile.keys())}

    if kind == "simulation":
        end = "s_end"
        enter = "s_enter"
        scaling = 1
    elif kind == "realtime":
        end = "r_end"
        enter = "r_enter"
        scaling = 1
    else:
        raise Exception("unknown kind")

    m_end = 0
    for k in profile.keys():
        for i in profile[k]:
            if end in i.keys():
                m_end = max(m_end, i[end])

    m_enter = m_end
    for k in profile.keys():
        for i in profile[k]:
            if enter in i.keys():
                m_enter = min(m_enter, i[enter])

    for k in profile.keys():
        for i in profile[k]:
            if end in i.keys() and enter in i.keys():
                i["name"] = k
                i[enter] = (max(i[enter], 0) - m_enter) / scaling
                i[end] = (max(i[end], 0) - m_enter) / scaling
                profiles.append(i)

    _, axs = plt.subplots(1, 1, figsize=(16, 9))
    ax = axs

    for d in profiles:
        ax.barh(names[d["name"]], d[end] - d[enter], left=d[enter])

    ax.set_xlabel("Time (s)")
    ax.set_yticks([i for i in range(0, len(names))])
    ax.set_yticklabels(names.keys())
    plt.show()


if __name__ == "__main__":
    plot(profile(os.path.abspath(os.path.join(CURRENT_DIR, "../examples/pi-exchange/profile.txt"))))
