# **Multi-Machine Vagrant from XML**

This is a multi-machine Vagrant system that dynamically configures four systems from an XML file.

Provisioning scripts will make changes to `/etc/hosts` and `/etc/ssh/ssh_config` for easy access between systems.

## **Instructions**

```bash
vagrant up          # start and provision all systems
vagrant ssh         # ssh into master
vagrant ssh client  # ssh into client
vagrant halt client # shutdown client
vagrant halt        # shutdown reaming systems
```
