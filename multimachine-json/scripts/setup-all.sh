#!/usr/bin/env bash
# NAME: setup-all.sh
# AUTHOR: Joaquin Menchaca
# CREATED: 2015-11-23
#
# PURPOSE: Configures `/etc/hosts` and global ssh configuration for each
#  password-less system to system communication through ssh.
# DEPENDENCIES:
#  * GNU Bash, POSIX Commands (awk, grep)
#  * Global Configuration - JSON.sh, global.json
#  * VirtualBox Guest Editions installed on guest system
#  * Local host . directory mounted as /vagrant on guest system
# NOTES:
#  * This script will be run on the guest operating system

##### Fetch Global Data
CONFIG="/vagrant/config"
[ -e $CONFIG/global.json -o -e $CONFIG/JSON.sh ] || \
  { echo "ERROR: No global configuration exists. Exiting"; exit 1; }
JSON_DATA=$($CONFIG/JSON.sh -l < $CONFIG/global.json | grep '"ipaddr"')
##### Local Variables
SYSTEMS=$(echo "${JSON_DATA}" | awk 'BEGIN { FS = "\"" } { print $4}' )

cp /dev/null /etc/ssh/ssh_config

for SYSTEM in $SYSTEMS; do
  # Reference Identity File
  # Prerequisite:
  #   * local directory on host　must be mounted on guest system as
  #　  　/vagrant (default behavior)
  #   * guest-edtitions drivers must be installed on guest
  # Note: As these are created when the machine is brought up, they may not be available.
  #       Thus we have to reference where they will be located in the future.
  IDENTITYFILE=/vagrant/.vagrant/machines/${SYSTEM}/virtualbox/private_key

  if ! grep -q -F "Host ${SYSTEM}" /etc/ssh/ssh_config; then
    ### CREATE GLOBAL SSH CONFIG
    cat <<-CONFIG_EOF >> /etc/ssh/ssh_config
Host ${SYSTEM}
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  IdentitiesOnly yes
  User vagrant
  IdentityFile ${IDENTITYFILE}
  PasswordAuthentication no
CONFIG_EOF
  fi

  ### CREATE HOSTS
  IPADDRESS=$(echo "${JSON_DATA}" | grep "${SYSTEM}" | awk '{ print $2 }' | tr -d '"')
  grep -q -F "${IPADDRESS} ${SYSTEM}" /etc/hosts || echo "${IPADDRESS} ${SYSTEM}" >> /etc/hosts
done
