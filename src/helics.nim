# -*- coding: utf-8 -*-

import strutils
import strformat
import httpclient
import json
import mimetypes
import ospaths
import osproc
import threadpool
import os
import sequtils
import sugar
import terminal
from os import sleep

proc monitor(p: Process, log_file: string) =
  var o: File

  var l = log_file.open(fmAppend)

  assert open(o, p.outputHandle(), fmRead)
  while p.peekExitCode() == -1:
    l.write(o.readLine())

  assert open(o, p.errorHandle(), fmRead)
  var line: TaintedString
  while o.readLine(line):
    l.write(line)

proc run(path: string) =
  var path_to_config = path
  path_to_config.normalizePath()
  let dirname = parentDir(path_to_config)

  if not dirExists(path_to_config):
    echo(&"Unable to find file `config.json` in path: {path_to_config}")
    return

  var f = open(path_to_config, fmRead)
  var config = parseJson(f.readAll())

  echo(&"""Running federation: {config["name"]}""")

  var processes = newSeq[Process]()

  for f in config["federates"]:

    let name = f["name"].getStr
    echo(&"""Running federate {name} as a background process""")

    let directory = joinPath(dirname, f["directory"].getStr)

    let p = startProcess(f["exec"].getStr, expandTilde(directory))

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
  )
