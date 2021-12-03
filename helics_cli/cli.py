# -*- coding: utf-8 -*-
"""
HELICS Runner command line interface
"""

import json
import logging
import os
import shlex
import shutil
import subprocess
from multiprocessing import Queue

import click

from .utils.message_handler import MessageHandler
from .utils.process import ProcessHandler
from . import observer
from ._version import __version__
from .exceptions import HELICSRuntimeError
from .server import startup
from .status_checker import CheckStatusThread
from .utils import extra
from .utils.extra import echo
from . import profile as p

logger = logging.getLogger(__name__)

process_handler = ProcessHandler(
    process_list=[], output_list=[], has_web=False, message_handler=MessageHandler(Queue(), Queue(), False), use_broker_process=False
)


@click.group()
@click.version_option(__version__, "--version")
@click.option("--verbose", "-v", count=True)
@click.pass_context
def cli(ctx, verbose):
    """
    HELICS Runner command line interface
    """
    ctx.obj = {}
    ctx.obj["verbose"] = verbose
    if verbose != 0:
        extra.VERBOSE = verbose


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
            {"name": "Federate1", "host": "localhost", "exec": """python -c 'print("hello")'""", "directory": path},
            {"name": "Federate2", "host": "localhost", "exec": """python -c 'print("hello")'""", "directory": path},
        ],
    }
    with open(os.path.join(path, "config.json"), "w") as f:
        f.write(json.dumps(config, indent=4, sort_keys=True, separators=(",", ":")))

    print(os.path.join(path, "config.json"))


@cli.command()
@click.option(
    "--path",
    required=True,
    type=click.Path(file_okay=True, exists=True),
    help="Path to profile.txt that describes profiling results of a federation",
)
def profile(path):
    p.plot(p.profile(path), kind="realtime")


@cli.command()
@click.option(
    "--path",
    required=True,
    type=click.Path(file_okay=True, exists=True),
    help="Path to config.json that describes how to run a federation",
)
@click.option("--silent", is_flag=True)
@click.option("--no-log-files", is_flag=True, default=False)
@click.option("--no-kill-on-error", is_flag=True, default=False, help="Do not kill all federates on error")
@click.option(
    "--broker-loglevel",
    "--loglevel",
    "-l",
    type=str,
    default="error",
    help="Log level for HELICS broker",
)
@click.option(
    "--profile",
    is_flag=True,
    default=False,
    help="Profile flag",
)
@click.option("--web", "-w", is_flag=True, default=False, help="Run the web interface on startup")
def run(path, silent, no_log_files, broker_loglevel, web, no_kill_on_error, profile):
    """
    Run HELICS federation
    """
    log = not no_log_files
    kill_on_error = not no_kill_on_error
    path_to_config = os.path.abspath(path)
    path = os.path.dirname(path_to_config)

    if not os.path.exists(path_to_config):
        echo(
            "Unable to find file `config.json` in path: {path_to_config}".format(path_to_config=path_to_config),
            status="error",
        )
        return None

    with open(path_to_config) as f:
        config = json.loads(f.read())

    logger.debug("Read config: %s", config)

    if not silent:
        echo("Running federation: {name}".format(name=config["name"]), status="info")

    if web and "broker" in config.keys() and "observer" in config["broker"].keys():
        process_handler.message_handler.set_enable(True)

    if web:
        process_handler.run_web(
            target=startup,
            args=(
                False,
                path_to_config,
                process_handler.message_handler,
            ),
            daemon=True,
        )

    if "broker" in config.keys() and config["broker"] is not False:
        if config["broker"] is not True and "observer" in config["broker"].keys():
            process_handler.run_broker(
                target=observer.run,
                args=(
                    len(config["federates"]),
                    path_to_config,
                    broker_loglevel,
                    process_handler.message_handler,
                ),
                daemon=True,
            )
            process_handler.broker_process.name = "broker"
        else:
            cmd = "helics_broker -f {num_fed} --loglevel={log_level}"
            if profile:
                profiler_txt = os.path.join(os.path.abspath(os.path.expanduser(path)), "profile.txt")
                if os.path.exists(profiler_txt):
                    os.remove(profiler_txt)
                cmd += " --profiler=profile.txt"
            broker_o = open(os.path.join(path, "broker.log"), "w")
            cmd = cmd.format(num_fed=len(config["federates"]), log_level=broker_loglevel)
            broker_subprocess = subprocess.Popen(
                shlex.split(cmd),
                cwd=os.path.abspath(os.path.expanduser(path)),
                stdout=broker_o,
                stderr=broker_o,
            )
            broker_subprocess.name = "broker"
            process_handler.process_list.append(broker_subprocess)
            process_handler.output_list.append(broker_o)
    else:
        broker_o = open(os.path.join(path, "broker.log"), "w")
        _ = subprocess.Popen(
            shlex.split("""python -c 'print("helics-cli not auto-generating broker.")'"""),
            cwd=os.path.abspath(os.path.expanduser(path)),
            stdout=broker_o,
            stderr=broker_o,
        )

    for f in config["federates"]:
        if not silent:
            echo(
                "Running federate {name} as a background process".format(name=f["name"]),
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
        process_handler.process_list.append(p)
        if o is not None:
            process_handler.output_list.append(o)

    t = CheckStatusThread(process_handler.process_list, kill_on_error)

    try:
        t.start()
        echo(
            "Waiting for {} processes to finish ...".format(len(process_handler.process_list)),
            status="info",
        )
        for p in process_handler.process_list:
            p.wait()
    except KeyboardInterrupt:
        echo("Warning: User interrupted processes. Terminating safely ...", status="info")
        process_handler.shutdown()
        logger.debug("Closing output")
        for o in process_handler.output_list:
            o.close()
        logger.debug("Shutting down Processes")
        for p in process_handler.process_list:
            p.kill()

    except HELICSRuntimeError as e:
        click.echo("")
        click.echo(f"Error: {e}. Terminating ...")
        if kill_on_error:
            process_handler.shutdown()
            for o in process_handler.output_list:
                o.close()
            for p in process_handler.process_list:
                p.kill()
    finally:
        for p in process_handler.process_list:
            if p.returncode != 0 and p.returncode is not None:
                echo(
                    "Process {} exited with return code {}".format(p.name, p.returncode),
                    status="error",
                )
    echo(
        "Done.",
        status="info",
    )


@cli.command()
@click.option(
    "--path",
    required=True,
    type=click.Path(exists=True),
    default="./",
    help="Path to config.json file that describes how to run a federation",
)
def validate(path):
    """
    Validate config.json
    """
    path = os.path.abspath(path)

    with open(path) as f:
        config = json.loads(f.read())

    if set(list(config.keys())) == {"name", "broker", "federates"}:
        echo("Missing or additional keys found in config.json", status="warning")

    echo(" - Valid keys in config.json", status="info")

    for i, f in enumerate(config["federates"]):
        assert "name" in f.keys(), "Missing name in federate number {i}".format(i=i)
        assert set(list(f.keys())) == {"name", "host", "exec", "directory"}, "Missing or additional keys found in federates {} in config.json".format(
            f["name"]
        )
        echo("     - Valid keys in federate {}".format(f["name"]), status="info")
        assert f["host"] == "localhost", "Multi machine support is currently not available. Please contact the developer."

    return None


@cli.command()
@click.option(
    "--n-federates",
    required=True,
    type=click.INT,
    help="Number of federates to observe",
)
@click.option("--path", type=click.Path(exists=True), default="./", help="Internal path to config file used for filtering output")
@click.option("--broker_loglevel", "--loglevel", "-l", type=click.INT, default=2, help="Log level for HELICS broker")
def observe(n_federates: int, path: str, log_level) -> int:
    return observer.run(n_federates, path, log_level)


@cli.command()
@click.option(
    "--browser",
    is_flag=True,
    default=False,
    help="Open browser on startup",
)
@click.option("--path", type=click.Path(exists=True), default="./", help="Path for database file")
def server(browser: bool, path: str):
    startup(browser, path)


if __name__ == "__main__":
    cli()
