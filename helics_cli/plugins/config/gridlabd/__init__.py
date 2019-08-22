# -*- coding: utf-8 -*-
import os
import shutil

from helics_cli.plugins.config.base import BaseConfig
from helics_cli.templates import ConfigGenerator
from helics_cli.utils import abs2rel, echo, mkdir

import glm

from jinja2 import Template

current_directory = os.path.dirname(os.path.realpath(__file__))

with open(
    os.path.abspath(os.path.join(current_directory, "./gridlabd-federate-config.json"))
) as f:
    gridlabd_config_template = Template(f.read())


class GridLABDConfigGenerator(ConfigGenerator):

    template = gridlabd_config_template

    def setup(self, publications, subscriptions, **kwargs):
        for k, v in kwargs.items():
            self.config[k] = v

        self.config["publications"] = {}
        self.config["subscriptions"] = {}
        for k, v in publications.items():
            gld_object = v["mapping"].split("/")[0]
            gld_fieldname = v["mapping"].split("/")[1]
            helics_topic = k

            try:
                self.config["publications"][gld_object]
            except KeyError:
                self.config["publications"][gld_object] = {}

            self.config["publications"][gld_object][gld_fieldname] = helics_topic

        for k, v in subscriptions.items():
            gld_object = v["mapping"].split("/")[0]
            gld_fieldname = v["mapping"].split("/")[1]
            helics_topic = k

            try:
                self.config["subscriptions"][gld_object]
            except KeyError:
                self.config["subscriptions"][gld_object] = {}

            self.config["subscriptions"][gld_object][gld_fieldname] = helics_topic


class GridLABDConfig(BaseConfig):
    def run(self):
        for r in self.runner_items:
            self.runner.append(r)

    def setup(self):
        self.working_directory = self.config.pop("working_directory")
        self.simulation_file = self.config.pop("simulation_file")
        self.runner_items = []

        # echo(self.config, status="debug")
        for federate_name, data in self.config.items():

            federate_name = federate_name.replace("/", "_")
            echo(f"Setting up gridlabd for {federate_name}")
            gld_directory = os.path.join(self.working_directory, federate_name)
            mkdir(gld_directory)
            if not os.path.isabs(data["dataroot"]):
                data["dataroot"] = os.path.abspath(
                    os.path.join(
                        os.path.dirname(self.simulation_file), data["dataroot"]
                    )
                )

            # TODO: not all files will be located in dataroot
            original_model = os.path.join(
                data["dataroot"], data["folder"], data["model"]
            )
            working_directory_model = os.path.join(
                gld_directory, "{}.glm".format(federate_name)
            )

            self._setup_gridlabd(original_model, working_directory_model, federate_name)
            g = GridLABDConfigGenerator(
                name=federate_name,
                publications=data["publications"],
                subscriptions=data["subscriptions"],
            )
            g.write(
                os.path.join(
                    os.path.dirname(working_directory_model),
                    "{}.json".format(federate_name),
                )
            )

            self.runner_items.append(
                {
                    "name": federate_name,
                    "host": "localhost",
                    "exec": "gridlabd {}.glm".format(federate_name),
                    "directory": abs2rel(gld_directory, self.working_directory),
                }
            )

    def _setup_gridlabd(self, original_model, working_directory_model, federate_name):

        original_folder = os.path.dirname(original_model)
        working_directory_folder = os.path.dirname(working_directory_model)

        with open(original_model) as f:
            try:
                data = glm.loads(f.read())
            except Exception as e:
                echo("Unable to load {}".format(original_model), status="error")
                raise e

            # # Fix includes
            # if n["head"]["type"] == "Include":
            # resource = n["attributes"]["name"].strip("'").strip('"')
            # original_resource = os.path.abspath(
            # os.path.join(original_folder, resource)
            # )
            # mkdir(working_directory_folder)
            # working_directory_resource = os.path.join(
            # working_directory_folder, os.path.basename(original_resource)
            # )
            # shutil.copyfile(original_resource, working_directory_resource)
            # working_directory_resource = abs2rel(
            # working_directory_resource, working_directory_folder
            # )
            # n["attributes"]["name"] = '"{}"'.format(working_directory_resource)

        # Loop through all objects and update paths for all include files to our new directory
        for n in data["objects"]:

            # Fix climate related
            if n["name"] == "climate":
                resource = n["attributes"]["tmyfile"].strip("'").strip('"')
                original_resource = os.path.abspath(
                    os.path.join(original_folder, resource)
                )
                mkdir(working_directory_folder)
                working_directory_resource = os.path.join(
                    working_directory_folder, os.path.basename(original_resource)
                )
                working_directory_resource = os.path.abspath(working_directory_resource)
                shutil.copyfile(original_resource, working_directory_resource)
                working_directory_resource = abs2rel(
                    working_directory_resource, working_directory_folder
                )
                n["attributes"]["tmyfile"] = (
                    '"{}"'.format(working_directory_resource).strip("'").strip('"')
                )

            # Fix player files
            if n["name"] == "player":
                resource = n["attributes"]["file"].strip("'").strip('"')
                original_resource = os.path.abspath(
                    os.path.join(original_folder, resource)
                )
                mkdir(working_directory_folder)
                working_directory_resource = os.path.join(
                    working_directory_folder, os.path.basename(original_resource)
                )
                shutil.copyfile(original_resource, working_directory_resource)
                working_directory_resource = abs2rel(
                    working_directory_resource, working_directory_folder
                )
                n["attributes"]["file"] = (
                    '"{}"'.format(working_directory_resource).strip("'").strip('"')
                )

            # Fix recorder files
            if n["name"] in [
                "tape.recorder",
                "tape.group_recorder",
                "tape.collector",
                "collector",
            ]:
                output_filename = n["attributes"]["file"]
                if os.path.isabs(output_filename):
                    output_filename = abs2rel(output_filename, original_folder)

                # output_filename is guarenteed to be a relative path here
                output_filename = os.path.abspath(
                    os.path.join(working_directory_folder, output_filename)
                )

                if os.path.dirname(output_filename) != "" or os.path.normpath(
                    output_filename
                ) != os.path.basename(output_filename):
                    mkdir(os.path.dirname(output_filename))

                n["attributes"]["file"] = (
                    abs2rel(output_filename, working_directory_folder)
                    .strip("'")
                    .strip('"')
                )

        # Loop through all objects to find the network node
        for i, n in enumerate(data["objects"]):
            if (
                "bustype" in n["attributes"].keys()
                and n["attributes"]["bustype"] == "SWING"
            ):
                if n["name"] == "meter":
                    echo("Replacing SWING bus meter with substation", status="warning")
                    nominal_voltage = n["attributes"]["nominal_voltage"]
                    phases = n["attributes"]["phases"]
                    # substation_name = n["attributes"]["name"]
                    n["attributes"].pop("bustype")
                    data["objects"].pop(i)
                    substation = {
                        "name": "substation",
                        "attributes": {
                            "phases": "{}".format(phases),
                            "nominal_voltage": nominal_voltage,
                            "name": "network_node_substation",
                            "bustype": "SWING",
                        },
                        "children": [n],
                    }
                    data["objects"].insert(i, substation)
                    break

        # TODO: Fix modules as well as objects
        list_to_pop = []
        for i, n in enumerate(data["objects"]):
            if n["name"] == "helics_msg":
                list_to_pop.append(i)

        for i in list_to_pop[::-1]:
            data["objects"].pop(i)

        connection_module = {"name": "connection", "attributes": {}}

        data["modules"].append(connection_module)

        helics_object = {
            "name": "helics_msg",
            "attributes": {
                "name": "{}".format(federate_name),
                "configure": "{}.json".format(federate_name),
            },
            "children": [],
        }

        data["objects"].insert(0, helics_object)

        with open(working_directory_model, "w") as f:
            f.write(glm.dumps(data))
