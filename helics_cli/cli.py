# -*- coding: utf-8 -*-
"""
HELICS Runner command line interface
"""

import logging
import json
import os
import shutil
import subprocess
import shlex
from pkg_resources import iter_entry_points

import click

from ._version import __version__

# from .log import setup_logger
from .status_checker import CheckStatusThread
from .exceptions import HELICSRuntimeError

from .simulation.configure import SimulationConfigurer
from . import utils
from .utils import echo
from . import plugins

logger = logging.getLogger(__name__)


def _register():

    for entry_point in iter_entry_points("helics_cli.plugins.config"):
        name, cls = entry_point.name, entry_point
        plugins.registered_config[name] = cls


@click.group()
@click.version_option(__version__, "--version")
@click.option("--verbose", "-v", count=True)
@click.pass_context
def cli(ctx, verbose):
    """
    HELICS Runner command line interface
    """
    _register()
    ctx.obj = {}
    ctx.obj["verbose"] = verbose
    if verbose != 0:
        utils.VERBOSE = verbose


@cli.command()
@click.option(
    "--name",
    type=click.STRING,
    default="HELICSFederation",
    help="Name of the folder that contains the config.json",
)
@click.option("--path", type=click.Path(), default="./", help="Path to the folder")
@click.option("--purge/--no-purge", default=False, help="Delete folder if it exists")
def setup(name, path, purge):
    """
    Setup HELICS federation
    """
    path = os.path.abspath(os.path.join(path, name))
    if purge:
        echo("Deleting folder: {path}".format(path=path), status="warning")
        try:
            shutil.rmtree(path)
        except FileNotFoundError:
            logger.warning("Unable to delete folder, folder does not exist: %s", path)

    if not os.path.exists(path):
        logger.debug("Creating folder at the path provided")
        os.makedirs(path)
    else:
        echo(
            "The following path already exists: {path}".format(path=path),
            status="error",
        )
        echo("Please remove the directory and try again.", status="error")
        return None

    config = {
        "name": name,
        "broker": False,
        "federates": [
            {
                "name": "Federate1",
                "host": "localhost",
                "exec": "python federate1.py",
                "directory": path,
            },
            {
                "name": "Federate2",
                "host": "localhost",
                "exec": "python federate2.py",
                "directory": path,
            },
        ],
    }
    with open(os.path.join(path, "config.json"), "w") as f:
        f.write(json.dumps(config, indent=4, sort_keys=True, separators=(",", ":")))


@cli.command()
@click.pass_context
@click.option(
    "--simulation-file",
    required=True,
    type=click.Path(exists=True),
    help="Path to file that contains the master simulation information",
)
@click.option(
    "--workspace-dir",
    required=True,
    type=click.Path(exists=True),
    help="Path to folder where workspace should be created",
    default=".",
)
def configure(ctx, simulation_file, workspace_dir, **kwargs):
    """
    Set up a simulation from a simulation.json file.
    """
    echo("Setting up simulation from {}".format(os.path.abspath(simulation_file)))

    SimulationConfigurer(simulation_file, workspace_dir)

    echo("Success!")


@cli.command()
@click.option(
    "--path",
    required=True,
    type=click.Path(file_okay=True, exists=True),
    help="Path to config.json that describes how to run a federation",
)
@click.option("--silent", is_flag=True)
@click.option("--no-log-files", is_flag=True, default=False)
@click.option("--broker-loglevel", type=int, default=2)
def run(path, silent, no_log_files, broker_loglevel):
    """
    Run HELICS federation
    """
    log = not no_log_files
    path_to_config = os.path.abspath(path)
    path = os.path.dirname(path_to_config)

    if not os.path.exists(path_to_config):
        echo(
            "Unable to find file `config.json` in path: {path_to_config}".format(
                path_to_config=path_to_config
            ),
            status="error",
        )
        return None

    with open(path_to_config) as f:
        config = json.loads(f.read())

    logger.debug("Read config: %s", config)

    if not silent:
        echo("Running federation: {name}".format(name=config["name"]), status="info")

    broker_o = open(os.path.join(path, "broker.log"), "w")
    if config["broker"] is True:
        broker_p = subprocess.Popen(
            shlex.split(
                "helics_broker -f {num_fed} --loglevel={log_level}".format(
                    num_fed=len(config["federates"]), log_level=broker_loglevel
                )
            ),
            cwd=os.path.abspath(os.path.expanduser(path)),
            stdout=broker_o,
            stderr=broker_o,
        )
    else:
        broker_p = subprocess.Popen(
            shlex.split("echo 'Using internal broker'"),
            cwd=os.path.abspath(os.path.expanduser(path)),
            stdout=broker_o,
            stderr=broker_o,
        )
    broker_p.name = "broker"

    process_list = []
    output_list = []

    for f in config["federates"]:

        if not silent:
            echo(
                "Running federate {name} as a background process".format(
                    name=f["name"]
                ),
                status="info",
            )

        if log is True:
            o = open(os.path.join(path, "{}.log".format(f["name"])), "w")
        else:
            o = None
        try:
            directory = os.path.join(path, f["directory"])

            env = dict(os.environ)
            if "env" in f:
                for k, v in f["env"].items():
                    env[k] = v
            p = subprocess.Popen(
                shlex.split(f["exec"]),
                cwd=os.path.abspath(os.path.expanduser(directory)),
                stdout=o,
                stderr=o,
                env=env,
            )

            p.name = f["name"]
        except FileNotFoundError as e:
            raise click.ClickException("FileNotFoundError: {}".format(e))
        process_list.append(p)
        if o is not None:
            output_list.append(o)

    process_list.append(broker_p)
    t = CheckStatusThread(process_list)

    try:
        t.start()
        echo(
            "Waiting for {} processes to finish ...".format(len(process_list)),
            status="info",
        )
        for p in process_list:
            p.wait()
    except KeyboardInterrupt:
        echo(
            "Warning: User interrupted processes. Terminating safely ...", status="info"
        )
        for p in process_list:
            p.kill()
    except HELICSRuntimeError as e:
        click.echo("")
        click.echo(f"Error: {e}. Terminating ...")
        for p in process_list:
            p.kill()
    finally:
        for p in process_list:
            if p.returncode != 0:
                echo(
                    "Process {} exited with return code {}".format(
                        p.name, p.returncode
                    ),
                    status="error",
                )

    broker_p.wait()
    echo("Done!", status="info")

    for o in output_list:
        o.close()

    broker_o.close()


@cli.command()
@click.option(
    "--path",
    required=True,
    type=click.Path(exists=True),
    help="Path to config.json file that describes how to run a federation",
)
def validate(path):
    """
    Validate config.json
    """
    path = os.path.abspath(path)

    with open(path) as f:
        config = json.loads(f.read())

    if set(list(config.keys())) == set(["name", "broker", "federates"]):
        echo("Missing or additional keys found in config.json", status="warning")

    echo(" - Valid keys in config.json", status="info")

    for i, f in enumerate(config["federates"]):
        assert "name" in f.keys(), "Missing name in federate number {i}".format(i=i)
        assert set(list(f.keys())) == set(
            ["name", "host", "exec", "directory"]
        ), "Missing or additional keys found in federates {name} in config.json".format(
            f["name"]
        )
        echo(
            "     - Valid keys in federate {name}".format(name=f["name"]), status="info"
        )
        assert (
            f["host"] == "localhost"
        ), "Multi machine support is currently not available. Please contact the developer."

    return None


if __name__ == "__main__":
    cli(verbose=True)
