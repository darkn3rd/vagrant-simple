#!/usr/bin/env ruby

time = Time.now.strftime("%Y%m%d%H%M%S")

settings = {
    "hosts" => {
        "client" => "192.168.53.23",
        "master" => "192.168.53.24",
        "slave1" => "192.168.53.25",
        "slave2" => "192.168.53.26"
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

settings['hosts'].each do |hostname, ipaddr|
  puts "default: #{settings['defaults'][hostname] || false}"
  puts "hostname = #{hostname}"
  puts "private_network, ip: #{ipaddr}"
  puts "vbox_name = #{hostname}_#{time}"
  puts "provision_script = scripts/#{hostname}.sh"
  if settings['ports'][hostname]
    puts "forwarded ports"
    settings['ports'][hostname].each do |forward|
      puts "- forwarded_port, guest: #{forward['guest']}, host: #{forward['host']}"
    end
  end
  puts "\n"
end
