#!/bin/sh
# NAME: setup-all.sh (from INI file)
# AUTHOR: Joaquin Menchaca
# CREATED: 2015-11-23
# UPDATED: 2016-04-24
#
# PURPOSE: Configures `/etc/hosts` and global ssh configuration for each
#  password-less system to system communication through ssh.
# DEPENDENCIES:
#  * GNU Bash, POSIX Commands (awk, grep)
#  * xml2 utility
#  * Global Configuration - global.ini
#  * VirtualBox Guest Editions installed on guest system
#  * Local host . directory mounted as /vagrant on guest system
# NOTES:
#  * This script will be run on the guest operating system

##### Dependencies
PARSER="./iniparse.awk"
[ -e ${CONFIGFILE} ] || \
  { echo "ERROR: ${PARSER} is missing. Exiting"; exit 1; }

##### Fetch Hosts
CONFIGFILE="global.ini"

[ -e ${CONFIGFILE} ] || \
  { echo "ERROR: ${CONFIGFILE} doesn't exist. Exiting"; exit 1; }

HOSTS_DATA=$(${PARSER} < ${CONFIGFILE} | grep hosts | sed 's/^hosts\.//' | tr -s '="' ' ')
HOSTS=$(echo "${HOSTS_DATA}" | cut -d ' ' -f1)

##### Local Variables
SSH_CONFIG="/etc/ssh/ssh_config"
HOSTS_FILE="etc/hosts"
cp /dev/null ${SSH_CONFIG}

for HOST in $HOSTS; do
  # Reference Identity File
  # Prerequisite:
  #   * local directory on host　must be mounted on guest system as
  #　  　/vagrant (default behavior)
  #   * guest-edtitions drivers must be installed on guest
  # Note: As these are created when the machine is brought up, they may not be available.
  #       Thus we have to reference where they will be located in the future.
  IDENTITYFILE=/vagrant/.vagrant/machines/${HOST}/virtualbox/private_key

  if ! grep -q -F "Host ${HOST}" ${SSH_CONFIG}; then
    ### CREATE GLOBAL SSH CONFIG
    cat <<-CONFIG_EOF >> ${SSH_CONFIG}
Host ${HOST}
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  IdentitiesOnly yes
  User vagrant
  IdentityFile ${IDENTITYFILE}
  PasswordAuthentication no
CONFIG_EOF
  fi

  ### CREATE HOSTS
  IPADDRESS=$(echo "${HOSTS_DATA}" | cut -d ' ' -f2)
  # append entry if it does not already exist
  grep -q -F "${IPADDRESS} ${HOST}" ${HOSTS_FILE} || echo "${IPADDRESS} ${HOST}" >> ${HOSTS_FILE}
done
