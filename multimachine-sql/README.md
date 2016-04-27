# **Multi-Machine Vagrant from SQLite3 database**

This is a multi-machine Vagrant system that dynamically configures four systems from SQLite3 database.  

Provisioning scripts will make changes to `/etc/hosts` and `/etc/ssh/ssh_config` for easy access between systems.

## **Prerequisites**

```
vagrant plugin install sqlite3
```

## **Nerd Notes**

Difficulty in running arbitrary SQL file into the database with `sqlite3` ruby library, so used `sqlite3` command-line tool to run this.

## **Instructions**

```bash
vagrant up          # start and provision all systems
vagrant ssh         # ssh into master
vagrant ssh client  # ssh into client
vagrant halt client # shutdown client
vagrant halt        # shutdown reaming systems
```