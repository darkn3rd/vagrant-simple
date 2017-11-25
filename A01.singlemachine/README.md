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

## **Testing with ServerSpec**

You can test using ServerSpec.  You'll have to install ServerSpec (`gem install serverspec`). These are only tested from Mac OS X host with Ruby 2.4.1.

You can run these using the test harness:

```bash
rake spec
```

Or you can manually orchestrate it and use:

```bash
TARGET_HOST=default rspec
```
