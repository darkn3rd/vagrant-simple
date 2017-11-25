# **A01: Single Machine**

This is static single machine configuration that demonstrates basics options configured in the `Vagrantfile`:

* **General**
    * Changing Hostname
    * Adding Private Network
    * Adding NAT Port Mappings (demo only, nothing connected)
* **Provider (Virtualbox)**
    * Changing virtual machine Label with timestamp
* **Provisioning**
    * Shell Script (inline)
      * Install/Remove Packages
      * Configure MOTD (Message of the Day)

## **Instructions**

Under a single-machine scenario there is only one system created called `default`.

```bash
vagrant up      # create virtual guest, start up, provision system
vagrant ssh     # ssh into system through localhost
vagrant destroy # delete virtual guest
```

You can alternatively login using the private IP address:

```bash
ssh vagrant@192.168.53.72
```

## **Testing with ServerSpec**

You can test using ServerSpec.  You'll have to install ServerSpec (`gem install serverspec`).

You can run these using the test harness:

```bash
rake spec   # test n systems (only one system)
```

Or you can manually orchestrate it and use:

```bash
TARGET_HOST=default rspec # test specified system
```
