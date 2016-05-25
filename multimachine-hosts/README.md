# **Multi-Machine Vagrant from Hosts file**

This is a multi-machine Vagrant system that dynamically configures four systems from `hosts` configuration file and other space-delimited files.  

## **Notes**

Provisioning scripts will make changes to `/etc/hosts` and `/etc/ssh/ssh_config` for easy access between systems.  After entering one system, e.g. `vagrant ssh client`, you can easily get to another system using just the host name, e.g. `ssh master`.

## **Instructions**

```bash
vagrant up          # start and provision all systems
vagrant ssh         # ssh into master
vagrant ssh client  # ssh into client
vagrant halt client # shutdown client
vagrant halt        # shutdown reaming systems
```

### **Ansible Inventory**

A sample Python script is available for testing an Ansible dynamic inventory file.  With Ansible installed on a Linux or Mac OS X host, you can run:

```bash
ansible all -i "inventory.py" -m ping
# run a single command
ansible all -i "inventory.py" -a 'lsb_release -a'
```

***Note***: This first time this is run, you may have to add the unique hash to known hosts, just type `yes` at the prompts.  If you destroy the machines (`vagrant destroy`) and recreate them (`vagrant up`), you'll have to purge their entries in `~/.ssh/known_hosts`, as the entries will be in an invalid state.  

Reference `man ssh` for more information.
