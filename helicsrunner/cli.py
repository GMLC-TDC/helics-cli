"""
HELICS cli
"""

import logging
import json
import os
import shutil

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
@click.option("--path", type=click.Path(file_okay=False), default="./")
@click.option("--purge/--no-purge", default=False)
def setup(path, purge):
    """
    Setup HELICS federation
    """
    path = os.path.abspath(path)
    if purge:
        logger.info("Deleting folder: %s", path)
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
def run():
    """
    Run HELICS federation
    """
    pass


if __name__ == "__main__":
    cli()
