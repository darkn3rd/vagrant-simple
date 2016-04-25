#!/usr/bin/env ruby

time = Time.now.strftime("%Y%m%d%H%M%S")

# Build Ruby structure (HoHoLoH) from 3 space seperated file data structure
settings = {'hosts'=>{}, 'ports'=>{}, 'defaults'=>{}}  # empty data-structure
# Read Hosts File
#  Format is 'ipaddress hostname'
File.readlines('global.hosts').map(&:chomp).each do |line|
  ipaddr, hostname = line.split(/\s+/)
  settings['hosts'][hostname] = ipaddr
end

# Read Defaults File
#  Format is 'hostname'
File.readlines('global.defaults').map(&:chomp).each do |line|
  settings['defaults'][line] = true
end

# Read Ports File
#  Format is 'hostname guest:host,guest:host'
File.readlines('global.ports').map(&:chomp).each do |line|
 hostname, forwards = line.split(/\s+/)
 settings['ports'][hostname] = []
 forwards.split(/,/).each do |forward|
   guest, host = forward.split(/:/)
   settings['ports'][hostname] << {'guest'=>guest, 'host'=>host}
 end
end

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
