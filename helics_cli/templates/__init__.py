# -*- coding: utf-8 -*-
import os
from jinja2 import Environment, PackageLoader, select_autoescape

from ..utils import abs2rel

env = Environment(
    loader=PackageLoader("helics_cli", "templates"),
    autoescape=select_autoescape(["json"]),
)


helics_config_template = env.get_template("helics-federate-config.json")
python_federate_template = env.get_template("main.py")
python_config_template = env.get_template("python-federate-config.json")

helics_cli_template = env.get_template("helics-runner-config.json")


class ConfigGenerator(object):

    template = None

    def __init__(self, **kwargs):
        # TODO: fix kwargs
        self.config = {}
        publications = kwargs.pop("publications", {})
        subscriptions = kwargs.pop("subscriptions", {})

        self.setup(publications=publications, subscriptions=subscriptions, **kwargs)

    def setup(self, **kwargs):
        raise NotImplementedError("Subclass ConfigGenerator to implement setup")

    def render(self):
        return self.template.render(**self.config)

    def write(self, file):

        with open(os.path.abspath(file), "w") as f:
            f.write(self.render())


class HELICSConfigGenerator(ConfigGenerator):

    template = helics_config_template

    def setup(self, publications, subscriptions, **kwargs):
        for k, v in kwargs.items():
            self.config[k] = v
        self.config["publications"] = publications
        self.config["subscriptions"] = subscriptions


class PythonConfigGenerator(ConfigGenerator):

    template = python_config_template

    def setup(self, name, publications, subscriptions, **kwargs):

        for k, v in kwargs.items():
            self.config[k] = v

        self.config["name"] = name
        self.config["publications"] = []
        self.config["subscriptions"] = []

        for k, v in subscriptions.items():
            assert k == v
            self.config["subscriptions"].append(k)

        for k, v in publications.items():
            assert k == v
            self.config["publications"].append(k)

    def write(self, file):

        super().write(file)

        with open(os.path.abspath(file.replace(".json", ".py")), "w") as f:
            f.write(python_federate_template.render(config=os.path.basename(file)))


class HELICSRunnerGenerator(object):

    template = helics_cli_template

    def __init__(self, name, federates, start_broker=True, **kwargs):
        self.config = {}
        self.config["name"] = name
        self.config["federates"] = federates
        self.config["start_broker"] = start_broker
        for k, v in kwargs.items():
            self.config[k] = v

    def render(self):
        return self.template.render(**self.config)

    def write(self, file):
        with open(file, "w") as f:
            f.write(self.render())
