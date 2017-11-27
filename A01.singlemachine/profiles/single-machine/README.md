# **InSpec Profile**

Inspec Profile for testing Single Machine scenario.


## **Installation**

```bash
gem install inspec
```

## **Instructions**

```bash
vagrant ssh-config > ssh-config
TARGET_HOST=$(grep -w HostName ssh-config | awk '{ print $2 }')
TARGET_USER=$(grep -w User ssh-config | awk '{ print $2 }')
TARGET_PORT=$(grep -w Port ssh-config | awk '{ print $2 }')
TARGET_IDENT=$(grep -w IdentityFile ssh-config | awk '{ print $2 }')
inspec exec profiles/single-machine \
        -t ssh://${TARGET_USER}@${TARGET_HOST} \
        -p ${TARGET_PORT} \
        -i ${TARGET_IDENT}
```
