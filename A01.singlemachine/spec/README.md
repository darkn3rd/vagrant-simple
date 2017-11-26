# **ServerSpec Tests**

ServerSpec scripts stored by vagrant machine name.

## **Installation**

```bash
gem install serverspec
```

## **Instructions**

Run using test harness (rake):

```bash
rake spec   # test n systems (only one system)
```

Manually run spec tests by manually specifying target host:

```bash
TARGET_HOST=default rspec # test specified system
```
