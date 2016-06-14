# NAME: baselib.src (baselib.sh)
# AUTHOR: Joaquin Menchaca
# CREATED: 2015-11-23
# UPDATED:
#   * 2016-04-24 support multiple data formats
#   * 2016-06-13 built library to support any file
#
# PURPOSE: Script library used for configuring `/etc/hosts` and
#  `/etc/ssh/ssh_config` for easy password-less system to system communication
#  through ssh.
# DEPENDENCIES:
#  * Ubuntu 14.04 Trusty Tahr
#  * GNU Bash 3+, POSIX Commands (cut, awk, grep, printf, sed, tr)
#  * Global Configuration - global.(csv|hosts|ini|json|sql|xml|yaml)
#  * VirtualBox Guest Editions installed on guest system
#  * Local host . directory mounted as /vagrant on guest system
#  * Packages: jq, xml2, sqlite3
# NOTES:
#  * This script will be run on the guest operating system
#  * parse_yaml from https://gist.github.com/pkuczynski/8665367

#######
# install()
#
# description: installs package on ubuntu 14
# usage: install $PACKAGE_NAME
##########################################
install() {
  PACKAGE="${1}"
  if ! dpkg -l ${PACKAGE} > /dev/null; then
    apt-get -y -qq install ${PACKAGE} > /dev/null
  fi

  command -v ${PACKAGE}  > /dev/null || \
    { echo "ERROR: ${PACKAGE} not found. Install ${PACKAGE} or ensure it is in your path";
      return 3; }
}

#######
# parse_yaml()
#
# description: flattens YAML file
# usage: parse_yaml $YAMLFILE
##########################################
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

#######
# parse_ini()
#
# description: flattens INI file w/ sep of '.'
# usage: parse_ini < $INIFILE
##########################################
parse_ini() {
  awk '!/^$/ {
    if ((start = index($0, "[")) != 0) {
        size = index(substr($0, start + 1), "]")
        section = substr($0, start+1, size-1)
    } else {
      print section "." $0
    }
  }'
}


#######
# get_hostdata()
#
# description: prints space delmited columns from output
# usage: get_hostdata $CONFIGFILE
##########################################

get_hostdata_by_ini() {
  echo "$(parse_ini < ${1} | grep -F hosts | sed 's/^hosts\.//' | tr -s '="' ' ')"
}

get_hostdata_by_json() {
  install jq

  ##### Output Results
  echo "$(jq -c '.hosts' < ${1} | tr -d '{}"' | tr ':,' ' \n')"
}

get_hostdata_by_sql() {
  ##### Install & Verify Required Tool
  install sqlite3
  ##### Fetch Hosts
  CONFIGDB="$(echo ${1} | cut -d. -f1).db"
  [ -e ${CONFIGDB} ] || sqlite3 ${CONFIGDB} ".read ${1}"  # build db if not exist
  ##### Output Results
  echo "$(printf ".mode column\n SELECT hostname, ipaddr FROM hosts;" | sqlite3 ${CONFIGDB} | tr -s ' ')"

}

get_hostdata_by_xml() {
  ##### Install & Verify Required Tool
  install xml2
  ##### Output Results
  echo "$(xml2 < ${1} | grep -F hosts | tr -s '/=' ' ' | cut -d' ' -f4,5)"
}

get_hostdata_by_yaml() {
  echo "$(parse_yaml ${1} | grep -F hosts | sed 's/_hosts_//' | tr -s '="' ' ')"
}

get_hostdata() {
  [ $# -le 1 ] || \
    { echo "USAGE: get_hostnames $CONFIGFILE"; return 1; }

  CONFIG_TYPE=${1##*.}
  case "${CONFIG_TYPE}" in
    ini)      echo "$(get_hostdata_by_ini  ${CONFIGFILE})" ;;
    json)     echo "$(get_hostdata_by_json ${CONFIGFILE})" ;;
    sql)      echo "$(get_hostdata_by_sql  ${CONFIGFILE})" ;;
    xml)      echo "$(get_hostdata_by_xml  ${CONFIGFILE})" ;;
    yaml|yml) echo "$(get_hostdata_by_yaml ${CONFIGFILE})" ;;
  esac
}

#######
# get_hostnames()
#
# description: prints list of hosts from given file
# usage: get_hostnames $CONFIGFILE
##########################################

get_hostnames_by_hostdata() {
  echo "$(get_hostdata $1)" | cut -d ' ' -f1
}

get_hostnames_by_csv () {
   echo $(sed '1d' < ${1} | cut -d, -f1)
}

get_hostnames_by_hosts () {
  echo $(tr -s ' ' < "${1}" | cut -d ' ' -f2)
}

get_hostnames () {
  [ $# -le 1 ] || \
    { echo "USAGE: get_hostnames $CONFIGFILE"; return 1; }

  CONFIGFILE=$1
  [ -e ${CONFIGFILE} ] || \
    { echo "ERROR: ${CONFIGFILE} doesn't exist."; return 2; }

  # Call Appropriate Function For Configuration File Type
  CONFIG_TYPE=${1##*.}
  case "${CONFIG_TYPE}" in
    csv)
      echo $(get_hostnames_by_csv       ${CONFIGFILE}) ;;
    hosts)
      echo $(get_hostnames_by_hosts     ${CONFIGFILE}) ;;
    ini|json|sql|xml|yaml|yml)
      echo $(get_hostnames_by_hostdata  ${CONFIGFILE}) ;;
  esac
}

#######
# get_ipaddress()
#
# description: prints ipaddress given configfile path and hostname
# usage: get_ipaddress $CONFIGFILE $HOSTNAME
##########################################

get_ipaddress_by_csv () {
  # strip header, get 2nd field from match
  echo $(sed '1d' < ${1} | grep -F "${2}" | cut -d, -f2)
}

get_ipaddress_by_hosts () {
  # squeeze extra spaces, get 1st field from match
  echo $(tr -s ' ' < "${1}" | grep -F "${2}" | cut -d ' ' -f1)
}

get_ipaddress_by_hostdata () {
  # retreive hostdata, get 2nd field from match
  echo "$(get_hostdata ${1})" | grep -F "${2}" | cut -d ' ' -f2
}

get_ipaddress () {
  [ $# -le 2 ] || \
    { echo "USAGE: get_ipaddress $CONFIGFILE $HOSTNAME"; return 1; }

  HOSTNAME=$2
  CONFIGFILE=$1

  [ -e ${CONFIGFILE} ] || \
    { echo "ERROR: ${CONFIGFILE} doesn't exist."; return 2; }

  # Call Appropriate Function For Configuration File Type
  CONFIG_TYPE=${1##*.}
  case "${CONFIG_TYPE}" in
    csv)
      echo $(get_ipaddress_by_csv   ${CONFIGFILE} ${HOSTNAME}) ;;
    hosts)
      echo $(get_ipaddress_by_hosts ${CONFIGFILE} ${HOSTNAME}) ;;
    ini|json|sql|xml|yaml|yml)
      echo $(get_ipaddress_by_hostdata  ${CONFIGFILE} ${HOSTNAME}) ;;
  esac
}

#######
# config_ssh()
#
# description: configures ssh_config given configuration file path
# usage: config_ssh $CONFIGFILE
##########################################
config_ssh () {
  [ $# -le 1 ] || \
    { echo "ERROR: Must supply configfile as parameter"; return 1; }

  CONFIGFILE=$1
  SSH_CONFIG=${2:-"/etc/ssh/ssh_config"}
  HOSTS=$(get_hostnames ${CONFIGFILE})

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
    IDENTITYFILE="/vagrant/.vagrant/machines/${HOST}/virtualbox/private_key"

    if ! grep -qF "Host ${HOST}" ${SSH_CONFIG}; then
      ### CREATE GLOBAL SSH CONFIG
      cat <<- CONFIG_EOF >> ${SSH_CONFIG}
  Host ${HOST}
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    IdentitiesOnly yes
    User vagrant
    IdentityFile ${IDENTITYFILE}
    PasswordAuthentication no
CONFIG_EOF
    fi
  done

}

#######
# config_hosts()
#
# description: configures hosts given configuration file path
# usage: config_hosts $CONFIGFILE
##########################################
config_hosts () {
  [ $# -le 1 ] || \
    { echo "ERROR: Must supply configfile as parameter"; return 1; }

  CONFIGFILE=$1
  HOSTS_FILE=${2:-"/etc/hosts"}
  HOSTS=$(get_hostnames ${CONFIGFILE})

  for HOST in ${HOSTS}; do
    if [ "$(hostname)" = "${HOST}" ]; then continue; fi
    ### APPEND TO HOSTS IF EXACT ENTRY NOT EXIST
    IPADDRESS=$(get_ipaddress ${CONFIGFILE} ${HOST})
    grep -Fq "${IPADDRESS} ${HOST}" ${HOSTS_FILE} || echo "${IPADDRESS} ${HOST}" >> ${HOSTS_FILE}
  done
}
