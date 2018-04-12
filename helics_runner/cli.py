"""
HELICS Runner command line interface
"""

import logging
import json
import os
import shutil
import subprocess
import shlex

import click

from ._version import __version__
from .log import setup_logger

logger = logging.getLogger(__name__)


@click.group()
@click.version_option(__version__, '--version')
@click.option('--verbose/-no-verbose', default=False)
def cli(verbose):
    """
    HELICS Runner command line interface
    """
    if verbose is True:
        setup_logger()


@cli.command()
@click.option("--name", type=click.STRING, default="HELICSFederation", help="Name of the folder that contains the config.json")
@click.option("--path", type=click.Path(), default="./", help="Path to the folder")
@click.option("--purge/--no-purge", default=False, help="Delete folder if it exists")
def setup(name, path, purge):
    """
    Setup HELICS federation
    """
    path = os.path.abspath(os.path.join(path, name))
    if purge:
        click.secho("Warning: ", bold=True, nl=False)
        click.echo("Deleting folder: {path}".format(path=path))
        try:
            shutil.rmtree(path)
        except FileNotFoundError:
            logger.warning("Unable to delete folder, folder does not exist: %s", path)

    if not os.path.exists(path):
        logger.debug("Creating folder at the path provided")
        os.makedirs(path)
    else:
        click.secho('Error: ', bold=True, nl=False)
        click.echo("The following path already exists: {path}".format(path=path), err=True)
        click.echo("Please remove the directory and try again.", err=True)
        return None

    config = {
        "name":
        name,
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
        ]
    }
    with open(os.path.join(path, "config.json"), "w") as f:
        f.write(json.dumps(config, indent=4, sort_keys=True, separators=(',', ':')))


@cli.command()
@click.option("--path", type=click.Path(file_okay=True), default="./HELICSFederation/config.json")
@click.option("--silent", is_flag=True)
def run(path, silent):
    """
    Run HELICS federation
    """
    path_to_config = os.path.abspath(path)
    path = os.path.dirname(path_to_config)

    if not os.path.exists(path_to_config):
        click.secho("Error: ", bold=True, nl=False)
        click.echo("Unable to find file `config.json` in path: {path_to_config}".format(path_to_config=path_to_config))
        return None

    with open(path_to_config) as f:
        config = json.loads(f.read())

    logger.debug("Read config: %s", config)

    if not silent:
        click.echo("Running federation: {name}".format(name=config["name"]))

    process_list = []
    output_list = []

    for f in config["federates"]:

        if not silent:
            click.echo("Running federate {name} as a background process".format(name=f["name"]))

        o = open(os.path.join(path, "{}.log".format(f["name"])), "w")
        try:
            directory = os.path.join(path, f["directory"])
            p = subprocess.Popen(shlex.split(f["exec"]), cwd=os.path.abspath(os.path.expanduser(directory)), stdout=o, stderr=o)
            p.name = f["name"]
        except FileNotFoundError as e:
            raise click.ClickException("FileNotFoundError: {}".format(e))
        process_list.append(p)
        output_list.append(o)

    try:
        click.echo("Waiting for {} processes to finish ...".format(len(process_list)))
        for p in process_list:
            p.wait()
    except KeyboardInterrupt as e:
        click.echo("")
        click.echo("Warning: User interrupted processes. Terminating safely ...")
        for p in process_list:
            p.kill()
    else:
        for p in process_list:
            if p.returncode != 0:
                click.echo("Error: Process {} exited with return code {}".format(p.name, p.returncode))

    click.echo("Done!")

    for f in output_list:
        f.close()


@cli.command()
@click.option("--path", type=click.Path())
def validate(path):
    """
    Validate config.json
    """
    path = os.path.abspath(path)

    if not os.path.exists(path):
        click.secho("Error: ", bold=True, nl=False)
        click.echo("Unable to find file `config.json` in path: {path}".format(path=path))
        return None

    with open(path) as f:
        config = json.loads(f.read())

    assert set(list(config.keys())) == set(["name", "federates"]), "Missing or additional keys found in config.json"

    click.echo(" - Valid keys in config.json")

    for i, f in enumerate(config["federates"]):
        assert "name" in f.keys(), "Missing name in federate number {i}".format(i=i)
        assert set(list(f.keys())) == set(["name", "host", "exec",
                                           "directory"]), "Missing or additional keys found in federates {name} in config.json".format(f["name"])
        click.echo("     - Valid keys in federate {name}".format(name=f["name"]))
        assert f["host"] == "localhost", "Multi machine support is currently not available. Please contact the developer."

    return None


if __name__ == "__main__":
    cli(verbose=True)
