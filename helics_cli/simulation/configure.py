# -*- coding: utf-8 -*-
import os
import json
import shutil

from ..exceptions import HELICSRuntimeError
from ..utils import echo, get_info, abs2rel
from ..templates import (
    HELICSConfigGenerator,
    PythonConfigGenerator,
    HELICSRunnerGenerator,
)
from ..utils import mkdir, copy_and_overwrite

from .. import plugins

# INFO = get_info()


class SimulationConfigurer(object):
    def __init__(self, simulation_file, workspace_dir=".", mock=None):

        self.simulation_file = os.path.abspath(simulation_file)
        self.working_directory = workspace_dir
        self.mock = mock
        self.runner = []

        echo("Reading the simulation file", status="info")

        with open(self.simulation_file) as f:
            self.simulation = json.loads(f.read())

        self.validate()

        self.create_simulation_directory()

        self.setup_federates()

        self.setup_runner()

    def validate(self):

        if "dataroot" in self.simulation.keys():
            echo(
                "dataroot specified in simulation.json, this is currently not supported and can lead to undefined behaviour.",
                status="warning",
            )
            echo("Moving dataroot to individual federates", status="debug")
            dataroot = self.simulation["dataroot"]
            del self.simulation["dataroot"]
            for federate_type in self.simulation["federates"]:
                for federate in self.simulation["federates"][federate_type]:
                    self.simulation["federates"][federate_type][federate][
                        "dataroot"
                    ] = dataroot

    def create_simulation_directory(self):

        self.working_directory = os.path.abspath(
            os.path.join(self.working_directory, "{}".format(self.simulation["name"]))
        )
        echo("Creating workspace in {}".format(self.working_directory), status="info")
        mkdir(self.working_directory)
        with open(os.path.join(self.working_directory, "simulation.json"), "w") as f:
            f.write(
                json.dumps(
                    self.simulation, sort_keys=True, separators=(",", ":"), indent=2
                )
            )

    def setup_federates(self):
        echo("Setting up federates", status="debug")

        for k, v in self.simulation["federates"].items():
            if k in plugins.registered_config.keys() and k != self.mock:
                cls = plugins.registered_config[k].load()
                self._setup_federate(cls, v)

        if self.mock is not None:
            echo("Setting up Python federates", status="debug")
            self.setup_python_federates()

    def _setup_federate(self, cls, v):
        echo("Setting up federate using {}".format(cls.__name__), status="info")

        federate_configuration = v
        federate_configuration["working_directory"] = self.working_directory
        federate_configuration["simulation_file"] = self.simulation_file

        c = cls(federate_configuration)

        for r in c.runner:
            self.runner.append(r)

    def setup_runner(self):
        echo("Setting up HELICS runner", status="info")

        name = self.simulation["name"]
        federates = self.runner
        h = HELICSRunnerGenerator(name=name, federates=federates)
        h.write(os.path.join(self.working_directory, "runner.json"))
        with open(os.path.join(self.working_directory, "runner.json")) as f:
            data = json.loads(f.read())
        with open(os.path.join(self.working_directory, "runner.json"), "w") as f:
            f.write(json.dumps(data, indent=2, sort_keys=True, separators=(",", ":")))

    def setup_python_federates(self):

        echo("Setting up Python Echo Federate", status="info")
        name = "PythonEchoFederate"
        python_directory = os.path.join(self.working_directory, name)
        self.runner.append(
            {
                "name": name,
                "host": "localhost",
                "exec": "python main.py",
                "directory": abs2rel(python_directory, self.working_directory),
            }
        )
        mkdir(python_directory)

        subscriptions = []
        publications = []

        raise NotImplementedError("Unable to implement mock Python federates")
