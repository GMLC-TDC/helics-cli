# -*- coding: utf-8 -*-
import logging
import inspect
import os
import getpass
import re
import shutil

import click

logger = logging.getLogger(__name__)

VERBOSE = False

extra = {"_filename": "utils.py"}
extra = {"_lineno": 98}

logger = logging.LoggerAdapter(logger, extra)


def get_info():
    return getpass.getuser()


def commonpath(l1, l2, common=[]):
    if len(l1) < 1:
        return (common, l1, l2)
    if len(l2) < 1:
        return (common, l1, l2)
    if l1[0] != l2[0]:
        return (common, l1, l2)
    return commonpath(l1[1:], l2[1:], common + [l1[0]])


def relpath(base, path):
    parent = ".." + os.path.sep
    baselist = [x for x in base.split(os.path.sep) if x != ""]
    pathlist = [x for x in path.split(os.path.sep) if x != ""]
    (common, l1, l2) = commonpath(baselist, pathlist)
    p = []
    if len(l1) > 0:
        p = [parent * len(l1)]
    p = p + l2
    if len(p) == 0:
        return "."
    return os.path.join(".{}".format(os.path.sep), *p)


def abs2rel(path, base=os.curdir):
    """
    return a relative path from base to path.

    base can be absolute, or relative to curdir, or defaults
    to curdir.
    """
    base = os.path.abspath(base)
    return relpath(base, path)


def _ignore(src, names):
    return [n for n in names if ".git" in n]


def copy_and_overwrite(from_path, to_path, ignore=_ignore):
    try:
        if os.path.exists(to_path):
            shutil.rmtree(to_path)
        shutil.copytree(from_path, to_path, ignore=ignore)
    except FileNotFoundError as e:
        echo(
            "Unable to copy from '{}'. Are you sure it exists?".format(from_path),
            status="warning",
        )
        raise e


def mkdir(directory):

    if os.path.exists(directory):
        echo(f"Removing existing directory: {directory}", status="warning")
        shutil.rmtree(directory)

    os.mkdir(directory)


def echo(*args, sep=" ", status="info", **kwargs):

    if len(args) == 1:
        string = args[0]
    else:
        string = sep.join(args)

    if VERBOSE >= 3:
        frameinfo = inspect.getframeinfo(inspect.stack()[1][0])
        try:
            extra["_filename"] = frameinfo.filename.split("/")[-1]
            extra["_lineno"] = frameinfo.lineno
        except Exception:
            extra["_filename"] = "utils.py"
            extra["_lineno"] = 97
        getattr(logger, status)(string)
    elif VERBOSE == 0:
        pass
    else:
        if status == "error" or status == "exception":
            fg = "red"
        elif status == "warning":
            fg = "blue"
        elif status == "debug":
            fg = "yellow"
        else:
            fg = "green"

        click.echo(
            click.style("helics-cli [{}]".format(status), fg=fg, bold=True),
            nl=False,
            **kwargs,
        )
        click.echo(": ", nl=False, **kwargs)

        click.echo(string, **kwargs)
