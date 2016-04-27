#!/usr/bin/env ruby

time = Time.now.strftime("%Y%m%d%H%M%S")

require 'inifile'
settings = IniFile.load('global.ini')
# Build Ruby structure (HoHoLoH) from INI data structure (HoH)
# Key=Value String format is 'hostname="guest:host,guest:host"'
settings['ports'].each  do |hostname,forwards|
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
