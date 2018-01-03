# helics-runner

Runner for Hierarchical Engine for Large-scale Infrastructure Co-Simulation (HELICS).

### Documentation

```bash
$ helics --help

Usage: helics [OPTIONS] COMMAND [ARGS]...

  HELICS Runner command line interface

Options:
  --version                Show the version and exit.
  --verbose / -no-verbose
  --help                   Show this message and exit.

Commands:
  run       Run HELICS federation
  setup     Setup HELICS federation
  validate  Validate config.json

```

```bash
$ helics setup --help
Usage: helics setup [OPTIONS]

  Setup HELICS federation

Options:
  --path PATH
  --purge / --no-purge
  --help                Show this message and exit.
```

```bash
$ helics run --help

Usage: helics run [OPTIONS]

  Run HELICS federation

Options:
  --path PATH
  --silent
  --help       Show this message and exit.
```

```bash
$ helics validate --help

Usage: helics validate [OPTIONS]

  Validate config.json

Options:
  --path PATH
  --help       Show this message and exit.
```

### Usage

```bash
$ helics setup --path examples/echo-federation

$ helics validate --path examples/echo-federation/config.json
 - Valid keys in config.json
     - Valid keys in federate Federate1
     - Valid keys in federate Federate2

$ helics run --path examples/echo-federation/config.json
Running federation: HELICSFederation
Running federate Federate1 as a background process
Running federate Federate2 as a background process
  [##################------------------]   50%
Hello from Federate 1
Hello from Federate 2
  [####################################]  100%

```

### Installation

```
pip install git+git://github.com/GMLC-TDC/helics-runner.git@master
```


