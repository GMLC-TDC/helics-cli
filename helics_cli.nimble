# Package

version       = "0.1.0"
author        = "Dheepak Krishnamurthy"
description   = "HELICS command line interface"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["helics"]

# Dependencies

requires "nim >= 1.2.0"
requires "cligen"
