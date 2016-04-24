#!/usr/bin/env ruby

time = Time.now.strftime("%Y%m%d%H%M%S")

# Parse JSON File into Ruby hash
require 'json'
json = open("global.json").read
machines = JSON.parse(json)

machines['hosts'].each do |hostname, ipaddr|
  #     default = machine['default'] || false
  #     config.vm.define name, primary: default, autostart: default do |cfg|
  puts "default: #{machines['defaults'][hostname] || false}"
  puts "hostname = #{hostname}"
  puts "private_network, ip: #{ipaddr}"
  puts "vbox_name = #{hostname}_#{time}"
  puts "provision_script = scripts/#{hostname}.sh"
  if machines['ports'][hostname]
    puts "forwarded ports"
    machines['ports'][hostname].each do |forward|
      puts "- forwarded_port, guest: #{forward['guest']}, host: #{forward['host']}"
    end
  end
  puts "\n"
end
