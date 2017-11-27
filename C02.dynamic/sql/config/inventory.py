#!/usr/bin/env python
"""
Vagrant external inventory script. Automatically finds the IP of the configured
vagrant vm(s), and returns it under the host group 'vagrant'

Example Vagrant configuration using this script:

    config.vm.provision :ansible do |ansible|
      ansible.playbook = "./provision/your_playbook.yml"
      ansible.inventory_file = "./provision/inventory/inventory.py"
      ansible.verbose = true
    end
"""

# Copyright (C) 2013  Mark Mandel <mark@compoundtheory.com>
#               2015  Igor Khomyakov <homyakov@gmail.com>
#               2016  Joaquin Menchaca <suavecali@yahoo.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#
# Thanks to the spacewalk.py inventory script for giving me the basic structure
# of this.
#

import sys
import os
from optparse import OptionParser
from collections import defaultdict
import sqlite3
try:
    import json
except:
    import simplejson as json

_script_home = os.path.dirname(os.path.realpath(__file__))
_config = os.environ.get('VAGRANT_CONFIG') or '{}/global.db'.format(_script_home)
_group  = 'vagrant'  # a default group
_sshkey = ".vagrant/machines/{0}/virtualbox/private_key"

#######
# main()
#
# description: parse options and return ansible formated json object
#              representing 1+ vagrant boxes (virtual systems)
##########################################
def main():
    # Options
    # ------------------------------
    parser = OptionParser(usage="%prog [options] --list | --host <machine>")
    parser.add_option('--list', default=False, dest="list", action="store_true",
                      help="Produce a JSON consumable grouping of Vagrant servers for Ansible")
    parser.add_option('--host', default=None, dest="host",
                      help="Generate additional host specific details for given host for Ansible")
    (options, args) = parser.parse_args()

    # List out servers that vagrant has running
    # ------------------------------
    if options.list:
        ssh_config = get_ssh_config()
        meta = defaultdict(dict)

        for host in ssh_config:
            meta['hostvars'][host] = ssh_config[host]

        print(json.dumps({_group: list(ssh_config.keys()), '_meta': meta}))
        sys.exit(0)

    # Get out the host details
    # ------------------------------
    elif options.host:
        print(json.dumps(get_a_ssh_config(options.host)))
        sys.exit(0)

    # Print out help
    # ------------------------------
    else:
        parser.print_help()
        sys.exit(0)

#######
# get_ssh_config()
#
# description: return dictionary of an ansible configs for all boxes
##########################################
def get_ssh_config():
    hostvars = {}
    QUERY_HOSTS = "SELECT hostname, ipaddr FROM hosts"

    con = None

    try:
        con = sqlite3.connect(_config)
        cur = con.cursor()
        cur.execute(QUERY_HOSTS)
        hosts = cur.fetchall()
    except sqlite3.Error, e:
        print "Error %s:" % e.args[0]
        sys.exit(1)
    finally:
        if con:
            con.close()

    # build hostvars dictionary from sql query result
    for hostname, ip in hosts:
        ansible_config = {}
        ansible_config['ansible_ssh_private_key_file'] = _sshkey.format(hostname)
        ansible_config['ansible_ssh_user'] = 'vagrant'
        ansible_config['ansible_ssh_host'] = ip # strip literal quote chars
        hostvars[hostname] = ansible_config

    return hostvars

#######
# get_a_ssh_config(box_name)
#
# description: return dictionary of an ansible config for single box
##########################################
def get_a_ssh_config(box_name):
    ansible_config = {}
    QUERY_IP = "SELECT ipaddr FROM hosts WHERE hostname = '{0}'"

    con = None

    try:
        con = sqlite3.connect(_config)
        cur = con.cursor()
        cur.execute(QUERY_IP.format(box_name))
        ip = cur.fetchone()[0] # dereference
    except sqlite3.Error, e:
        print "Error %s:" % e.args[0]
        sys.exit(1)
    finally:
        if con:
            con.close()

    # build return structure given ip
    ansible_config['ansible_ssh_private_key_file'] = _sshkey.format(box_name)
    ansible_config['ansible_ssh_user'] = 'vagrant'
    ansible_config['ansible_ssh_host'] = ip

    return ansible_config

if __name__ == "__main__":
    main()
