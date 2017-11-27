#!/usr/bin/env python
"""
Vagrant external inventory script. Automatically finds the IP of the configured
vagrant vm(s), and returns it under the host group 'vagrant'

Example Vagrant configuration using this script:

    config.vm.provision :ansible do |ansible|
      ansible.playbook = "./provision/your_playbook.yml"
      ansible.inventory_file = "./provision/inventory/vagrant.py"
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
try:
    import json
except:
    import simplejson as json

_script_home = os.path.dirname(os.path.realpath(__file__))
_config = os.environ.get('VAGRANT_CONFIG') or "{}/global.hosts".format(_script_home)
_group = 'vagrant'  # a default group

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

    # build hostvars dictionary from global hosts file
    for line in open(_config).readlines():
        ip, hostname = line.strip().split()
        ansible_config = {}
        ansible_config['ansible_ssh_private_key_file'] = ".vagrant/machines/{0}/virtualbox/private_key".format(hostname)
        ansible_config['ansible_ssh_user'] = 'vagrant'
        ansible_config['ansible_ssh_host'] = ip
        hostvars[hostname] = ansible_config

    return hostvars

#######
# get_a_ssh_config(box_name)
#
# description: return dictionary of an ansible config for single box
##########################################
def get_a_ssh_config(box_name):
    ansible_config = {}

    # find line with matching hostname
    for line in open(_config).readlines():
        ip, hostname = line.strip().split()
        if hostname == box_name:
            break

    # build return structure given ip from last line fetched
    ansible_config['ansible_ssh_private_key_file'] = ".vagrant/machines/{0}/virtualbox/private_key".format(box_name)
    ansible_config['ansible_ssh_user'] = 'vagrant'
    ansible_config['ansible_ssh_host'] = ip

    return ansible_config

if __name__ == "__main__":
    main()
