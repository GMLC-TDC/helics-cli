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

include ./src/utils
include ./src/validate
include ./src/run
include ./src/hook
include ./src/server

proc hook(federates: int): int =
  runHookFederate(federates)
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
    [ hook, noAutoEcho=true ],
    [ server, noAutoEcho=true ],
  )
