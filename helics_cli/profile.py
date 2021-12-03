# -*- coding: utf-8 -*-

import os
import re

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

CURRENT_DIR = os.path.realpath(os.path.basename(__file__))

# <PROFILING>SenderFederate2[131074](initializing)HELICS CODE ENTRY<4570827706580384>[t=-1000000]</PROFILING>
PATTERN = re.compile(
    r"""
            (?P<name>\w+)                           # SenderFederate2
            \[(\d+)\]                               # [131074]
            \((?P<state>\w+)\)                      # (initializing)
            (?P<message>(?:\w|\s)+)                 # HELICS CODE ENTRY
            \<(?P<realtime>\d+(?:\|\d+)?)\>         # <4570827706580384|534534523453>
            \[t=(?P<simtime>-?\d*\.{0,1}\d+)\]      # [t=-1000000]
            """,
    re.X,
)


def profile(filename, invert=True):
    with open(filename) as f:
        data = f.read()
    data = data.replace(r"<PROFILING>", "").replace(r"</PROFILING>", "")
    names = []
    states = []
    messages = []
    simtimes = []
    realtimes = []
    time_marker = {}
    for line in data.splitlines():
        m = PATTERN.match(line)
        name = m.group("name")
        state = m.group("state")
        message = m.group("message")
        simtime = float(m.group("simtime"))
        try:
            realtime = float(m.group("realtime"))
        except:
            realtime, markertime = m.group("realtime").split("|")
            time_marker[name] = float(markertime)
            realtime = float(realtime)
        names.append(name)
        states.append(state)
        messages.append(message)
        simtimes.append(simtime)
        realtimes.append(realtime)

    profile = {}
    for name in set(names):
        profile[name] = []

    if invert:
        for name in set(names):
            profile[name].append({})

    for (name, state, message, simtime, realtime) in zip(names, states, messages, simtimes, realtimes):
        if state == "created":
            continue
        if "ENTRY" in message and not invert:
            profile[name].append({"s_enter": simtime, "r_enter": realtime})
        elif "EXIT" in message and not invert:
            profile[name][-1]["s_end"] = simtime
            profile[name][-1]["r_end"] = realtime
        elif "EXIT" in message and invert:
            profile[name].append({"s_enter": simtime, "r_enter": realtime})
        elif "ENTRY" in message and invert:
            profile[name][-1]["s_end"] = simtime
            profile[name][-1]["r_end"] = realtime

    return profile


def plot(profile, save=None, kind="simulation", **kwargs):
    profiles = []
    names = {k: i for i, k in enumerate(sorted(profile.keys()))}

    if kind == "simulation":
        end = "s_end"
        enter = "s_enter"
        scaling = 1
    elif kind == "realtime":
        end = "r_end"
        enter = "r_enter"
        scaling = 1e9
    else:
        raise Exception("unknown kind")

    for k in profile.keys():
        for i in profile[k]:
            if end in i.keys() and enter in i.keys():
                i["name"] = k
                i[enter] = i[enter] / scaling
                i[end] = i[end] / scaling
                profiles.append(i)

    fig, axs = plt.subplots(1, 1, figsize=(16, 9))
    ax = axs

    cmap = matplotlib.cm.get_cmap("seismic")

    values = list(d[end] - d[enter] for d in profiles)
    norm = matplotlib.colors.Normalize(vmin=min(values), vmax=max(values))

    m_enter = min(d[enter] for d in profiles)
    for i, d in enumerate(profiles):
        d["color"] = cmap(norm(values[i]))

    for d in profiles:
        d[enter] = d[enter] - m_enter
        d[end] = d[end] - m_enter
        ax.barh(names[d["name"]], d[end] - d[enter], left=d[enter], edgecolor=d["color"], color=d["color"], **kwargs)

    if kind == "Simulation":
        ax.set_xlabel("Simulation Time (s)")
    else:
        ax.set_xlabel("Real Time (s)")
    ax.set_yticks([i for i in range(0, len(names))])
    ax.set_yticklabels(sorted(names.keys()))
    ax.set_facecolor("#f0f0f0")
    fig.colorbar(matplotlib.cm.ScalarMappable(norm=norm, cmap=cmap), ax=ax, location="top")
    if save is None:
        plt.show()
    else:
        plt.savefig(save, dpi=300)


if __name__ == "__main__":
    plot(profile(os.path.abspath(os.path.join(CURRENT_DIR, "../examples/pi-exchange/profile.txt"))), kind="realtime")
