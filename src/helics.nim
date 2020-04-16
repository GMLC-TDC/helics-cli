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

proc run(path: string) =
  echo path

when isMainModule:
  import cligen
  include cligen/mergeCfgEnv
  const nd = staticRead "../helics.nimble"
  clCfg.version = nd.fromNimble("version")
  dispatchMulti(
    [ run, noAutoEcho=true ],
  )
