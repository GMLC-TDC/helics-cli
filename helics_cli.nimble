# Package

version       = "0.3.2"
author        = "Dheepak Krishnamurthy"
description   = "HELICS command line interface"
license       = "MIT"
binDir        = "bin"
packageName   = "helics_cli"
bin           = @[packageName]

# Dependencies

requires "nim >= 1.2.0"
requires "cligen"
requires "shlex"
requires "jester"
requires "https://github.com/GMLC-TDC/helics.nim"

import strutils
import os
import strformat

before build:
  rmDir(binDir)

after build:
  when buildOS == "windows":
    let cli = packageName & ".exe"
  else:
    let cli = packageName
  mvFile binDir / cli, binDir / cli.replace("_cli", "")

proc package(packageOs: string, packageCpu: string) =
  let cli = packageName.replace("_cli", "")
  let assets = &"{cli}-v{version}-{packageOs}-{packageCpu}"
  let dist = "dist"
  let dist_dir = dist/assets
  rmDir dist_dir
  mkDir dist_dir
  cpDir binDir, dist_dir/binDir
  cpFile "LICENSE", dist_dir/"LICENSE"
  cpFile "README.md", dist_dir/"README.md"
  withDir dist:
    when buildOs == "windows":
      exec &"7z a {assets}.zip {assets}"
    else:
      exec &"""chmod +x ./{assets / binDir / cli}"""
      exec &"tar czf {assets}.tar.gz {assets}"
  rmDir dist_dir

task clean, "Clean project":
  rmDir(nimCacheDir())

task changelog, "Create a changelog":
  exec("./scripts/changelog.nim")

task debug, "Clean and build debug":
  exec "nimble clean"
  exec "nimble build"

task release, "Clean and build release":
  exec "nimble clean"
  exec &"nimble build --os:{buildOS} --cpu:{buildCpu} -d:release --opt:size -Y"
  package(buildOS, buildCpu)

task releasearm, "Clean and build release":
  exec "nimble clean"
  exec &"nimble build --os:{buildOS} --cpu:arm -d:release --opt:size -Y"
  package(buildOs, "arm")
