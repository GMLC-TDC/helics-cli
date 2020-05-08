
from os import sleep
import httpclient
import json
import mimetypes
import os
import osproc
import sequtils
import shlex
import strformat
import strutils
import sugar
import terminal
import threadpool
import streams
import strtabs


proc runValidate(path: string, silent = false): int =
  var path_to_config = path
  path_to_config.normalizePath()
  let dirname = parentDir(path_to_config)
  if not dirExists(dirname):
    print(&"Folder does not exist: {dirname}", sError)
    return 1

  var f: File
  var runner: JsonNode
  if open(f, path_to_config, fmRead):
    try:
      runner = parseJson(f.readAll())
    except:
      print("Unable to parse json file.", sError)
      return 1
    finally:
      f.close()

  else:
    print(&"File does not exist: {path_to_config}", sError)
    return 1

  if not runner.hasKey("name"):
    print("Runner configuration does not have a name field.", sError)
    return 1

  if not runner.hasKey("federates"):
    print("Runner configuration does not have a federates field.", sError)
    return 1

  for f in runner["federates"]:

    if not f.hasKey("name"):
      print(&"""federate {f} is missing a `name` field""", sError)
      return 1

    if not f.hasKey("name"):
      print(&"""federate {f["name"]} is missing a `exec` field""", sError)
      return 1

    if not f.hasKey("directory"):
      let directory = parentDir(path_to_config)
      print(&"""federate {f["name"]} is missing a `directory` field. Using {directory}.""", sWarn, silent = silent)

    if not f.hasKey("env"):
      print(&"""federate {f["name"]} is missing a `env` field. Using default environment.""", sWarn, silent = silent)


  print(&"No problems found in `{path_to_config}`.", silent = silent)
  return 0
