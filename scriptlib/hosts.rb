# -*- mode: ruby -*-
# vi: set ft=ruby :

############### CONSTANTS
CONFIGFILE_HOSTS=CONFIGFILE
CONFIGFILE_DEFAULTS=".#{CONFIGFILE.split(/\./)[1]}.defaults"
CONFIGFILE_PORTS=".#{CONFIGFILE.split(/\./)[1]}.ports"

############### GET CURRENT TIME
@time = Time.now.strftime("%Y%m%d%H%M%S")

############### BUILD RUBY DATA STRUCTURE (HoHoLoH)
@settings = {'hosts'=>{}, 'ports'=>{}, 'defaults'=>{}}  # empty data-structure
# Read Hosts File:  'ipaddress hostname'
File.readlines(CONFIGFILE_HOSTS).map(&:chomp).each do |line|
  ipaddr, hostname = line.split(/\s+/)
  @settings['hosts'][hostname] = ipaddr
end

# Read Defaults File: 'hostname'
File.readlines(CONFIGFILE_DEFAULTS).map(&:chomp).each do |line|
  @settings['defaults'][line] = true
end

# Read Ports File: 'hostname guest:host,guest:host'
File.readlines(CONFIGFILE_PORTS).map(&:chomp).each do |line|
 hostname, forwards = line.split(/\s+/)
 @settings['ports'][hostname] = []
 forwards.split(/,/).each do |forward|
   guest, host = forward.split(/:/)
   @settings['ports'][hostname] << {'guest'=>guest, 'host'=>host}
 end
end
