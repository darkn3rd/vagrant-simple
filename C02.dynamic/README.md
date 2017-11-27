# **Dynamically Created Multimachine from Configuration File**

This demonstration shows create a number of systems dynamically from a configuration file.

The configuration file format supported:

  * CSV
  * Hosts file
  * INI format
  * JSON
  * SQL (using SQLite)
  * XML
  * YAML

## **Datastructure**

The datastructure has the following format.

```ruby
@settings = {
    "hosts" => {
        "hostname" => "ipaddress",  # ipaddress e.g. 192.168.53.81
        "hostname" => "ipaddress"
    },
    "ports" => {
        "hostname" => [{
            "guest" => 80,
            "host" => 8080
        }]
    },
    "defaults" => {
        "master" => true
    }
}
```
