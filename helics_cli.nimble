# Package

version       = "0.1.0"
author        = "Dheepak Krishnamurthy"
description   = "HELICS command line interface"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["helics_cli"]

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
  let app = "helics_cli"
  let assets = &"{app}_{buildOS}"
  let dir = "dist"/assets
  mkDir dir
  cpDir "bin", dir/"bin"
  cpFile "LICENSE", dir/"LICENSE"
  cpFile "README.md", dir/"README.md"
  withDir "dist":
    when buildOS == "windows":
      exec &"7z a {assets}.zip {assets}"
    else:
      exec &"chmod +x ./{assets / \"bin\" / app}"
      exec &"tar czf {assets}.tar.gz {assets}"

task changelog, "Create a changelog":
  exec("./scripts/changelog.nim")
