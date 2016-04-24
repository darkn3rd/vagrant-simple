#!/bin/sh

##### Dependencies for JSON parsing
apt-get install -y jq

which -s jq || \
  { echo "ERROR: jq not found. Install jq or ensure it is in your path";
    exit 1; }

##### Fetch Hosts
CONFIGFILE="global.json"

[ -e ${CONFIGFILE} ] || \
  { echo "ERROR: No global configuration exists. Exiting"; exit 1; }

HOSTS_DATA=$(jq -c '.hosts' < ${CONFIGFILE} | tr -d '{}"' | tr ':,' ' \n')
HOSTS=$(echo "${HOSTS_DATA}" | cut -d ' ' -f1)

##### Local Variables
cp /dev/null /etc/ssh/ssh_config

for HOST in $HOSTS; do
  # Reference Identity File
  # Prerequisite:
  #   * local directory on host　must be mounted on guest system as
  #　  　/vagrant (default behavior)
  #   * guest-edtitions drivers must be installed on guest
  # Note: As these are created when the machine is brought up, they may not be available.
  #       Thus we have to reference where they will be located in the future.
  IDENTITYFILE=/vagrant/.vagrant/machines/${HOST}/virtualbox/private_key

  if ! grep -q -F "Host ${HOST}" /etc/ssh/ssh_config; then
    ### CREATE GLOBAL SSH CONFIG
    cat <<-CONFIG_EOF >> /etc/ssh/ssh_config
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
  HOSTS=$(echo "${HOSTS_DATA}" | cut -d ' ' -f2)
  grep -q -F "${IPADDRESS} ${HOST}" /etc/hosts || echo "${IPADDRESS} ${HOST}" >> /etc/hosts
done
