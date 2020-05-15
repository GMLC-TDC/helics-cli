# helics-cli

### Documentation

```
$ helics --help

Usage:
  helics {SUBCMD}  [sub-command options & parameters]
where {SUBCMD} is one of:
  help      print comprehensive or per-cmd help
  run
  validate
  observe
  server

helics {-h|--help} or with no args at all prints this message.
helics --help-syntax gives general cligen syntax help.
Run "helics {help SUBCMD|SUBCMD --help}" to see help for just SUBCMD.
Run "helics help" to get *comprehensive* help.
Top-level --version also available
```

```
$ helics run --help

run [required&optional-params]
Options:
  -p=, --path=   string  REQUIRED  set path
  -s, --silent   bool    false     set silent
```

```
$ helics validate --help

validate [required&optional-params]
Options:
  -p=, --path=   string  REQUIRED  set path
  -s, --silent   bool    false     set silent
```

```
$ helics observe [required&optional-params]
Options:
  -f=, --federates=  int   REQUIRED  set federates
```

```
$ helics server [optional-params]
```
