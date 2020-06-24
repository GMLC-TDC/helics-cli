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

import ./validate
import ./utils

when defined(windows):
  const ENV_COMMAND* = "set"
else:
  const ENV_COMMAND* = "env"

proc getEnv(): StringTableRef =
  var env = {:}.newStringTable
  when not defined(windows):
    for line in execProcess(ENV_COMMAND).splitLines():
      var s = line.split("=")
      env[s[0]] = join(s[1..s.high])
  return env


proc runRun*(path: string, silent = false): int =
  if runValidate(path, true) != 0:
    print("Runner json file is not per specification. Please check documentation for more information.", sError)
    return 1

  var config_path = path
  config_path.normalizePath()
  let dirname = parentDir(config_path)

  var f = open(config_path, fmRead)
  var runner = parseJson(f.readAll())

  print(&"""Running federation `{runner["name"].getStr}` with {runner["federates"].len} federates.""", silent = silent)

  let env =  getEnv()
  var processes = newSeq[Process]()
  var process_names = newSeq[string]()
  var threads = newSeq[FlowVar[int]]()

  for f in runner["federates"]:

    let name = f["name"].getStr
    print(&"""Running federate `{name}`.""", silent = silent)

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

    threads.add(spawn monitor(p, joinPath(dirname, &"""{name}.log""")))
    processes.add(p)
    process_names.add(name)

  var error_occured = false
  while not all(threads, r => r.isReady):
    os.sleep(250)
    for (i, t) in threads.pairs:
      if t.isReady and ^t != 0:
        print(&"""Something went wrong with federate `{process_names[i]}`. Please check the log files.""", sError)
        error_occured = true
    if error_occured:
      for p in processes:
        try:
          kill(p)
        except:
          discard
      break

  sync()

  if not error_occured: print("Success!")
