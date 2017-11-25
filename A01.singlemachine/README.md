# **A01: Single Machine**

This is static single machine configuration that demonstrates basics options configured in the `Vagrantfile`:

* **General**
    * Changing Hostname
    * Adding Private Network
    * Adding NAT Port Mappings
* **Provider (Virtualbox)**
    * Changing virtual machine Label with timestamp
* **Provisioning**
    * Shell Script (inline)
      * Install/Remove Packages
      * Configure MOTD (Message of the Day)

## **Instructions**

```bash
vagrant up      # start system and provision it
vagrant ssh     # to ssh into system
```
