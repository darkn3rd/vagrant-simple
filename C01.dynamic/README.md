# **Dynamically Created Multimachine**

This demonstration shows create a number of systems dynamically using a custom datastructure (in-memory Ruby hash).

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
