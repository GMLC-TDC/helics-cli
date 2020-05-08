# Package

version       = "0.2.1"
author        = "Dheepak Krishnamurthy"
description   = "HELICS command line interface"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
packageName   = "helics_cli"
bin           = @[packageName]

# Dependencies

requires "nim >= 1.2.0"
requires "cligen"
requires "shlex"
requires "nimcr"
requires "jester"

import strutils
import os
import strformat

task archive, "Create archived assets":
  let cli = packageName
  let assets = &"{cli}_v{version}_{buildOS}"
  let dist = "dist"
  let dist_dir = dist / assets
  rmDir dist_dir
  mkDir dist_dir
  mvFile "bin" / cli, "bin" / cli.replace("_cli", "")
  cpDir "bin", dist_dir/"bin"
  cpFile "LICENSE", dist_dir/"LICENSE"
  cpFile "README.md", dist_dir/"README.md"
  withDir dist:
    when buildOS == "windows":
      exec &"7z a {assets}.zip {assets}"
    else:
      exec &"""chmod +x ./{assets / "bin" / cli.replace("_cli", "")}"""
      exec &"tar czf {assets}.tar.gz {assets}"

task changelog, "Create a changelog":
  exec("./scripts/changelog.nim")
