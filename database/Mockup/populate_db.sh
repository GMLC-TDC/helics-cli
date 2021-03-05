#!/usr/bin/env bash

sqlite3 ../helics-cli.db ".read Populate_test_federates.sql"
sqlite3 ../helics-cli.db ".read Populate_test_messages.sql"
sqlite3 ../helics-cli.db ".read Populate_test_publications.sql"
