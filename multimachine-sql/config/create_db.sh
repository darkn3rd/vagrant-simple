#!/bin/sh
CONFIGFILE_DB="global.db"
CONFIGFILE_SQL="global.sql"

# Remove Database if it exists
[ -e ${CONFIGFILE_DB} ] && rm ${CONFIGFILE_DB}

# Check for SQLite3 Command
command -v sqlite3 2>&1 > /dev/null || { echo "ERROR: SQLite3 not installed" 1>&2; exit 1;}

# Create Database
sqlite3 ${CONFIGFILE_DB} ".read ${CONFIGFILE_SQL}"
