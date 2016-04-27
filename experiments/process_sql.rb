#!/usr/bin/env ruby

time = Time.now.strftime("%Y%m%d%H%M%S")

QUERY_HOSTS="SELECT hostname, ipaddr FROM hosts"
QUERY_DEFAULT="SELECT hostname FROM hosts WHERE defaults = 1"
QUERY_PORTS="SELECT hostname, guest, host FROM ports"
# Data Structure
settings = {'hosts'=>{}, 'ports'=>{}, 'defaults'=>{}}
# Initialize SQLite3 (open database)
require 'sqlite3'
db = SQLite3::Database.open('global.db')
# Query Tables
db.execute( QUERY_HOSTS ) do |hostname, ipaddr|
  settings['hosts'][hostname] = ipaddr
end

db.execute( QUERY_DEFAULT ) do |row|
  hostname = row[0]
  settings['defaults'][hostname] = true
end

db.execute( QUERY_PORTS ) do |hostname, guest, host|
  (settings['ports'][hostname] ||=[]) << {'guest'=>guest, 'host'=>host}
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
