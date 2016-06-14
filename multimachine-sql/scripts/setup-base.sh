#!/usr/bin/env bash
# NAME: setup-base.sh
# AUTHOR: Joaquin Menchaca
# CREATED: 2015-11-23
# UPDATED:
#   * 2016-04-24 support multiple data formats
#   * 2016-06-13 built library to support any file
#
# PURPOSE: Configures `/etc/hosts` and global ssh configuration for each
#  password-less system to system communication through ssh.
# DEPENDENCIES:
#  * baselib.src
# NOTES:
#  * This script will be run on the guest operating system

##### Variables
CONFIGFILE=${VAGRANT_CONFIG:-"/vagrant/config/global.sql"}
SCRIPTDIR="/vagrant/scripts"

##### Verify Configuration Exists
[ -e ${CONFIGFILE} ] || \
  { echo "ERROR: ${CONFIGFILE} doesn't exist. Exiting"; exit 1; }

##### Source Base Library
. ${SCRIPTDIR}/baselib.src

##### Setup /etc/ssh_config and /etc/hosts
install sqlite3
config_ssh ${CONFIGFILE}
config_hosts ${CONFIGFILE}
