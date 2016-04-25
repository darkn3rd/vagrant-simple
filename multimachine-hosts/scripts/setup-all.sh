#!/usr/bin/env bash
# NAME: setup-all.sh (from hosts file)
# AUTHOR: Joaquin Menchaca
# CREATED: 2015-11-23
# UPDATED: 2016-04-24
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

CONFIGFILE="/vagrant/config/global.hosts"
SSH_CONFIG="/etc/ssh/ssh_config"
HOSTS_FILE="/etc/hosts"
##### Fetch Hosts
[ -e ${CONFIGFILE} ] || \
  { echo "ERROR: ${CONFIGFILE} doesn't exist. Exiting"; exit 1; }

HOSTS=$(tr -s ' ' < "${CONFIGFILE}" | cut -d ' ' -f2)

##### Local Variables
cp /dev/null ${SSH_CONFIG}

for HOST in ${HOSTS}; do
  # Reference Identity File
  # Prerequisite:
  #   * local directory on host　must be mounted on guest system as
  #　  　/vagrant (default behavior)
  #   * guest-edtitions drivers must be installed on guest
  # Note: Refer to default Vagrant beahavior, as private_key created at time of
  #       machine creation
  IDENTITYFILE=/vagrant/.vagrant/machines/${HOST}/virtualbox/private_key

  if ! grep -qF "Host ${HOST}" ${SSH_CONFIG}; then
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

  ### APPEND TO HOSTS IF EXACT ENTRY NOT EXIST
  IPADDRESS=$(tr -s ' ' < "${CONFIGFILE}" | grep -F "${HOST}" | cut -d ' ' -f1)
  grep -Fq "${IPADDRESS} ${HOST}" ${HOSTS_FILE} || echo "${IPADDRESS} ${HOST}" >> ${HOSTS_FILE}
done
