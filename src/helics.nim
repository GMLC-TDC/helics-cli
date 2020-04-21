# -*- coding: utf-8 -*-

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

type
  Status = enum
    sInfo, sWarn, sError

proc print(msg: string, status = sInfo, silent = false) =
  if silent:
    return
  case status
  of sInfo:
    styledEcho(fgGreen, "[INFO] ", resetStyle, msg)
  of sWarn:
    styledEcho(fgYellow, "[WARN] ", resetStyle, msg)
  of sError:
    styledEcho(fgRed, "[ERROR] ", resetStyle, msg)


proc c_setvbuf(f: File, buf: pointer, mode: cint, size: csize_t): cint {. importc: "setvbuf", header: "<stdio.h>", tags: [] .}

when NoFakeVars:
  when defined(windows):
    const
      IOFBF = cint(0)
      IONBF = cint(4)
  else:
    # On all systems I could find, including Linux, Mac OS X, and the BSDs
    const
      IOFBF = cint(0)
      IONBF = cint(2)
else:
  var
    IOFBF {.importc: "_IOFBF", nodecl.}: cint
    IONBF {.importc: "_IONBF", nodecl.}: cint


proc monitor(p: Process, log_file: string) =

  var l = log_file.newFileStream(fmWrite)
  var o = p.outputStream()
  var f: File
  discard open(f, p.outputHandle(), fmRead)
  discard c_setvbuf(f, nil, IONBF, 0)
  var line = ""
  var buffer: array[10, char]

  while p.peekExitCode() == -1:
    o.flush()
    discard o.readLine(line)
    l.writeLine(line)
    l.flush()

when defined(windows):
  const ENV_COMMAND = "set"
else:
  const ENV_COMMAND = "env"

proc validate(path: string, silent = false): int =
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


proc run(path: string, silent = false): int =
  if validate(path, true) != 0:
    print("Runner json file is not per specification. Please check documentation for more information.", sError)
    return 1

  var path_to_config = path
  path_to_config.normalizePath()
  let dirname = parentDir(path_to_config)

  var f = open(path_to_config, fmRead)
  var runner = parseJson(f.readAll())

  print(&"""Running federation: {runner["name"]}""", silent = silent)

  var env = {:}.newStringTable
  for line in execProcess(ENV_COMMAND).splitLines():
    var s = line.split("=")
    env[s[0]] = join(s[1..s.high])

  var processes = newSeq[Process]()

  for f in runner["federates"]:

    let name = f["name"].getStr
    print(&"""Running federate {name} as a background process""", silent = silent)

    var directory: string
    if f{"directory"} != nil:
      directory = joinPath(dirname, f["directory"].getStr())
    else:
      directory = dirname

    # Get environment variables
    var process_env = deepcopy(env)
    if f{"env"} != nil:
      for k, v in f["env"].pairs:
        process_env[k] = v.getStr

    # TODO: check if valid command
    let cmd = f["exec"].getStr
    let p = startProcess(cmd, env = process_env, workingDir = directory, options = {poInteractive, poStdErrToStdOut, poEvalCommand})

    spawn monitor(p, joinPath(dirname, &"""{f["name"].getStr}.log"""))
    processes.add(p)

  sync()

  print("Success!")


when isMainModule:
  import cligen
  include cligen/mergeCfgEnv
  const nd = staticRead "../helics_cli.nimble"
  clCfg.version = nd.fromNimble("version")
  dispatchMulti(
    [ run, noAutoEcho=true ],
    [ validate, noAutoEcho=true ],
  )
