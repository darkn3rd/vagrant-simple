# -*- mode: ruby -*-
# vi: set ft=ruby :

############### CONSTANTS
CONFIGFILE_SQL=CONFIGFILE
CONFIGFILE_DB=".#{CONFIGFILE.split(/\./)[1]}.db"
QUERY_HOSTS="SELECT hostname, ipaddr FROM hosts"
QUERY_DEFAULT="SELECT hostname FROM hosts WHERE defaults = 1"
QUERY_PORTS="SELECT hostname, guest, host FROM ports"
############### GET CURRENT TIME
@time = Time.now.strftime("%Y%m%d%H%M%S")
############### BUILD RUBY DATA STRUCTURE (HoHoLoH)
# Data Structure
@settings = {'hosts'=>{}, 'ports'=>{}, 'defaults'=>{}}
# Initialize SQLite3 and Create Database
require 'sqlite3'
File.delete(CONFIGFILE_DB) if File.exist?(CONFIGFILE_DB) # delete, just in case
system "sqlite3 #{CONFIGFILE_DB} '.read #{CONFIGFILE_SQL}'" # sad but true
db = SQLite3::Database.open(CONFIGFILE_DB)

# Query Tables and stuff into hash
db.execute(QUERY_HOSTS) do |hostname, ipaddr|
  @settings['hosts'][hostname] = ipaddr
end

db.execute( QUERY_DEFAULT ) do |row|
  hostname = row[0]
  @settings['defaults'][hostname] = true
end

db.execute( QUERY_PORTS ) do |hostname, guest, host|
  (@settings['ports'][hostname] ||=[]) << {'guest'=>guest, 'host'=>host}
end
