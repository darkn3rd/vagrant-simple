# **Multi-Machine Vagrant with Ruby Hash**

This is a multi-machine Vagrant system that dynamically configures four systems using an in-memory Ruby hash.

## **Notes**

When visiting any guest machine, e.g. `vagrant ssh client`, you can only get to other systems through using the username and IP address, `ssh vagrant@192.168.53.84`.

## **Instructions**

```bash
vagrant up          # start and provision all systems
vagrant ssh         # ssh into master
vagrant ssh client  # ssh into client
vagrant halt client # shutdown client
vagrant halt        # shutdown reaming systems
```
