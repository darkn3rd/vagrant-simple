# **Testing Notes**

For testing, verify `/etc/ssh/ssh_config` and `/etc/hosts`

Using Ansible, you can test both Ansible and the configuration:

```bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible all -i "config/inventory.py" -m ping
ansible all -i "config/inventory.py" -a 'cat /etc/hosts'
ansible all -i "config/inventory.py" -a 'cat /etc/ssh/ssh_config'
```

From within the system, you can run:

```bash
for SYSTEM in client master slave1 slave2; do
  ssh -q $SYSTEM 'printf "HOSTNAME:%s\n\nHOSTS:\n%s\n\nSSH_CONFIG:\n%s\n\n" "$(hostname)" "$(cat /etc/hosts)" "$(cat /etc/ssh/ssh_config)";'
done
```
## **Configuration**

My host environment (6/2016):

* Host System Configuration:
  * Mac OS X *El Capitan* 10.11.5
  * Python 2.7.11
    * ansible (1.9.4)
    * configparser (3.5.0)
    * paramiko (1.16.0)
    * PyYAML (3.11)
    * vboxapi (1.0)
    * xmltodict (0.10.1)
  * Vagrant 1.8.1, vboxmanage 5.0.16r105871
  * Vagrant Plugins:
    * inifile (3.0.0)
    * sqlite3 (1.3.11)
    * vagrant-aws (0.7.0)
    * vagrant-aws-route53 (0.3.2)
    * vagrant-hostmanager (1.8.1)
    * vagrant-share (1.1.5, system)

## **Manual Test with Timings**

Time measurement with above base environment:

## **JSON**

| Test  | Time  |
|---|---|
| `vagrant up --no-provision `  | 2m46s  |
| `vagrant provision`  | 0m20s  |  
| `ansible -m ping`  | 0m5s  |
| `ansible - a  'cat /etc/hosts'` | 0m1s  |   
| `ansible -a 'cat /etc/ssh/ssh_config'` | 0m1s  |   
| `vagrant destroy --force` | 0m14s  |   


### **SQL**

| Test  | Time  |
|---|---|
| `vagrant up --no-provision `  | 2m30s  |
| `vagrant provision`  | 0m13s  |  
| `ansible -m ping`  | 0m9s  |
| `ansible - a  'cat /etc/hosts'` | 0m1s  |   
| `ansible -a 'cat /etc/ssh/ssh_config'` | 0m1s  |   
| `vagrant destroy --force` | 0m14s  |   

### **XML**

| Test  | Time  |
|---|---|
| `vagrant up --no-provision `  | 3m3s  |
| `vagrant provision`  | 0m20s  |  
| `ansible -m ping`  | 0m7s  |
| `ansible - a  'cat /etc/hosts'` | 0m1s  |   
| `ansible -a 'cat /etc/ssh/ssh_config'` | 0m1s  |   
| `vagrant destroy --force` | 0m16s  |   
