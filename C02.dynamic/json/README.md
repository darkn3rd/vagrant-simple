# **Multi-Machine Vagrant from JSON**

This is a multi-machine Vagrant system that dynamically configures four systems from a JSON file.

### **Notes**

Provisioning scripts will make changes to `/etc/hosts` and `/etc/ssh/ssh_config` for easy access between systems.  After entering one system, e.g. `vagrant ssh client`, you can easily get to another system using just the host name, e.g. `ssh master`.

## **Instructions**

```bash
vagrant up          # start and provision all systems
vagrant provision   # provision or re-provision all systems
vagrant ssh         # ssh into master
vagrant ssh client  # ssh into client
vagrant halt client # shutdown client
vagrant halt        # shutdown all systems
vagrant reload      # restart all systems
vagrant destroy     # delete all systems
```

### **Ansible Inventory**

A sample Python script is available for testing an Ansible dynamic inventory file.  With Ansible installed on a Linux or Mac OS X host, you can run:

```bash
vagrant up          # bring systems up
export ANSIBLE_HOST_KEY_CHECKING=False
ansible all -i "config/inventory.py" -m ping
# run a single command
ansible all -i "config/inventory.py" -a 'lsb_release -a'
```
