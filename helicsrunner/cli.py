"""
HELICS cli
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
    HELICS cli
    """
    if verbose is True:
        setup_logger()


@cli.command()
@click.option("--path", type=click.Path(file_okay=False), default="./HELICSFederation")
@click.option("--purge/--no-purge", default=False)
def setup(path, purge):
    """
    Setup HELICS federation
    """
    path = os.path.abspath(path)
    if purge:
        click.secho("Warning: ", bold=True, nl=False)
        click.echo("Deleting folder: {path}".format(path=path))
        try:
            shutil.rmtree(path)
        except FileNotFoundError:
            logger.warning("Unable to delete folder, folder does not exist: %s", path)
    if not os.path.exists(path):
        logger.debug("Creating folder at the path provided")
        os.mkdir(path)
    else:
        click.secho('Error: ', bold=True, nl=False)
        click.echo("The following path already exists: {path}".format(path=path), err=True)
        click.echo("Please remove the directory and try again.", err=True)

    config = {
        "name":
        "HELICSFederation",
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
    with open(path) as f:
        config = json.loads(f.read())

    logger.debug("Read config: %s", config)

    if not silent:
        click.echo("Running federation: {name}".format(name=config["name"]))

    process_list = []

    for f in config["federates"]:

        if not silent:
            click.echo("Running federate {name} as a background process".format(name=f["name"]))

        p = subprocess.Popen(shlex.split(f["exec"]), cwd=f["directory"])
        process_list.append(p)

    if not silent:
        with click.progressbar(process_list) as pl:
            for p in pl:
                p.wait()


if __name__ == "__main__":
    cli(verbose=True)
