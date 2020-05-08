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
requires "jester"

import strutils
import os
import strformat

task before_build, "Run before build":
  rmDir(binDir)

task after_build, "Run after build":
  let cli = packageName
  mvFile binDir / cli, binDir / cli.replace("_cli", "")

task clean, "Clean project":
  rmDir(nimCacheDir())

task archive, "Create archived assets":
  exec "nimble run"
  let cli = packageName.replace("_cli", "")
  let assets = &"{cli}_v{version}_{buildOS}"
  let dist = "dist"
  let dist_dir = dist/assets
  rmDir dist_dir
  mkDir dist_dir
  cpDir binDir, dist_dir/binDir
  cpFile "LICENSE", dist_dir/"LICENSE"
  cpFile "README.md", dist_dir/"README.md"
  withDir dist:
    when buildOS == "windows":
      exec &"7z a {assets}.zip {assets}"
    else:
      exec &"""chmod +x ./{assets / binDir / cli}"""
      exec &"tar czf {assets}.tar.gz {assets}"

task changelog, "Create a changelog":
  exec("./scripts/changelog.nim")

task debug, "Clean, build":
  exec "nimble clean"
  exec "nimble before_build"
  exec "nimble build"
  exec "nimble after_build"

task make, "Clean, build":
  exec "nimble clean"
  exec "nimble before_build"
  exec "nimble build -d:release --opt:size -Y"
  exec "nimble after_build"
