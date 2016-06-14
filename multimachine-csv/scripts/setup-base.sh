#!/usr/bin/env bash
# NAME: setup-all.sh
# AUTHOR: Joaquin Menchaca
# CREATED: 2015-11-23
# UPDATED:
#   * 2016-04-24
#   * 2016-06-13 built library to support any file
#
# PURPOSE: Configures `/etc/hosts` and global ssh configuration for each
#  password-less system to system communication through ssh.
# DEPENDENCIES:
#  * GNU Bash 3+, POSIX Commands (cut, grep, tr)
#  * Global Configuration - global.hosts
#  * VirtualBox Guest Editions installed on guest system
#  * Local host . directory mounted as /vagrant on guest system
# NOTES:
#  * This script will be run on the guest operating system

##### Variables
CONFIGFILE=${VAGRANT_CONFIG:-"/vagrant/config/global.hosts.csv"}
SCRIPTDIR="/vagrant/scripts"

##### Verify Configuration Exists
[ -e ${CONFIGFILE} ] || \
  { echo "ERROR: ${CONFIGFILE} doesn't exist. Exiting"; exit 1; }

##### Source Base Library
. ${SCRIPTDIR}/baselib.src

##### Setup /etc/ssh_config and /etc/hosts
config_ssh ${CONFIGFILE}
config_hosts ${CONFIGFILE}
