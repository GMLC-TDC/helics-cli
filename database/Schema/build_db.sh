#!/usr/bin/env bash

sqlite3 ../helics-cli.db ".read Messages.sql"
sqlite3 ../helics-cli.db ".read Federates.sql"
sqlite3 ../helics-cli.db ".read MetaData.sql"
sqlite3 ../helics-cli.db ".read Publications.sql"
