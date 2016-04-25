#!/usr/bin/env ruby
time = Time.now.strftime("%Y%m%d%H%M%S")

require 'nori'
parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_s })
xml = open("global.xml").read
settings = parser.parse(xml)['settings'] # retreive * under parent element

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
