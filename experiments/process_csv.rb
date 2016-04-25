#!/usr/bin/env ruby

time = Time.now.strftime("%Y%m%d%H%M%S")

settings = {'hosts'=>{}, 'ports'=>{}, 'defaults'=>{}}

require 'csv'
# SELECT * FROM global.host.csv
CSV.foreach('global.hosts.csv', :headers => true) do |row|
  settings['hosts'][row['hostname']] = row['ipaddr']
  settings['defaults'][row['hostname']] = true if row['defaults'] == "1"
end
# SELECT * FROM global.ports.csv
CSV.foreach('global.ports.csv', :headers => true) do |row|
  (settings['ports'][row['hostname']] ||=[]) << {'guest'=>row['guest'], 'host'=>row['host']}
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
