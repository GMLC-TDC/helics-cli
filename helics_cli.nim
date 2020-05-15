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

import ./src/validate as v
import ./src/run as r
import ./src/observe as o
import ./src/server as s

proc observe(federates: int): int =
  runObserverFederate(federates)
  return 0

proc validate(path: string, silent = false): int =
  return runValidate(path, silent)

proc run(path: string, silent = false): int =
   return runRun(path, silent)

proc server(): int =
  return runServer()

when isMainModule:
  import cligen
  include cligen/mergeCfgEnv
  const nd = staticRead "./helics_cli.nimble"
  clCfg.version = nd.fromNimble("version")
  dispatchMulti(
    [ run, noAutoEcho=true ],
    [ validate, noAutoEcho=true ],
    [ observe, noAutoEcho=true ],
    [ server, noAutoEcho=true ],
  )
