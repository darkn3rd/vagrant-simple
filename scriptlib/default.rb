# -*- mode: ruby -*-
# vi: set ft=ruby :

############### GET CURRENT TIME
@time = Time.now.strftime("%Y%m%d%H%M%S")

############### BUILD RUBY DATA STRUCTURE (HoHoLoH)
@settings = {
    "hosts" => {
        "client" => "192.168.53.83",
        "master" => "192.168.53.84",
        "slave1" => "192.168.53.85",
        "slave2" => "192.168.53.86"
    },
    "ports" => {
        "master" => [{
            "guest" => 80,
            "host" => 8080
        }, {
            "guest" => 3306,
            "host" => 13306
        }]
    },
    "defaults" => {
        "master" => true
    }
}
