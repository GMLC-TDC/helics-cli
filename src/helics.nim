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


proc monitor(p: Process, log_file: string) =
  var o: File

  var l = log_file.open(fmWrite)

  assert open(o, p.outputHandle(), fmRead)
  while p.peekExitCode() == -1:
    l.write(o.readAll())
    sleep(250)

  assert open(o, p.errorHandle(), fmRead)
  var line: TaintedString
  while o.readLine(line):
    l.writeLine(line)

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

  var processes = newSeq[Process]()

  for f in runner["federates"]:

    let name = f["name"].getStr
    print(&"""Running federate {name} as a background process""", silent = silent)

    let directory = joinPath(dirname, f["directory"].getStr)
    # TODO: check if valid command
    let p = startProcess(f["exec"].getStr, workingDir = directory, options = {poEvalCommand})

    spawn monitor(p, joinPath(dirname, &"""{f["name"].getStr}.log"""))
    processes.add(p)

  sync()


when isMainModule:
  import cligen
  include cligen/mergeCfgEnv
  const nd = staticRead "../helics_cli.nimble"
  clCfg.version = nd.fromNimble("version")
  dispatchMulti(
    [ run, noAutoEcho=true ],
    [ validate, noAutoEcho=true ],
  )
