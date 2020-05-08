
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
  Status* = enum
    sInfo, sWarn, sError

proc c_setvbuf(f: File, buf: pointer, mode: cint, size: csize_t): cint {. importc: "setvbuf", header: "<stdio.h>", tags: [] .}

var
  IOFBF {.importc: "_IOFBF", nodecl.}: cint
  IONBF {.importc: "_IONBF", nodecl.}: cint

proc print*(msg: string, status = sInfo, silent = false) =
  if silent:
    return
  case status
  of sInfo:
    styledEcho(fgGreen, "[INFO] ", resetStyle, msg)
  of sWarn:
    styledEcho(fgYellow, "[WARN] ", resetStyle, msg)
  of sError:
    styledEcho(fgRed, "[ERROR] ", resetStyle, msg)


proc monitor*(p: Process, log_file: string): int =

  var l = log_file.newFileStream(fmWrite)
  var o = p.outputStream()
  var f: File
  discard open(f, p.outputHandle(), fmRead)
  discard c_setvbuf(f, nil, IONBF, 0)
  var line = ""

  while p.peekExitCode() == -1:
    o.flush()
    discard o.readLine(line)
    l.writeLine(line)
    l.flush()

  return p.peekExitCode()
