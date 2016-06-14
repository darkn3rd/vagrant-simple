# -*- mode: ruby -*-
# vi: set ft=ruby :

############### CONSTANTS
CONFIGFILE_HOSTS=CONFIGFILE
CONFIGFILE_PORTS=".#{CONFIGFILE.split(/\./)[1]}.ports.csv"
############### GET CURRENT TIME
@time = Time.now.strftime("%Y%m%d%H%M%S")
############### BUILD RUBY DATA STRUCTURE (HoHoLoH)
@settings = {'hosts'=>{}, 'ports'=>{}, 'defaults'=>{}}

require 'csv'
# SELECT * FROM global.host.csv
CSV.foreach(CONFIGFILE_HOSTS, :headers => true) do |row|
  @settings['hosts'][row['hostname']] = row['ipaddr']
  @settings['defaults'][row['hostname']] = true if row['defaults'] == "1"
end
# SELECT * FROM global.ports.csv
CSV.foreach(CONFIGFILE_PORTS, :headers => true) do |row|
  (@settings['ports'][row['hostname']] ||=[]) << {'guest'=>row['guest'], 'host'=>row['host']}
end
