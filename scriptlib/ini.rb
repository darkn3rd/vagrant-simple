# -*- mode: ruby -*-
# vi: set ft=ruby :

############### GET CURRENT TIME
@time = Time.now.strftime("%Y%m%d%H%M%S")
############### BUILD RUBY DATA STRUCTURE (HoHoLoH)
require 'inifile'
@settings = IniFile.load(CONFIGFILE)
# Build Ruby structure (HoHoLoH) from INI data structure (HoH)
# Key=Value String format is 'hostname="guest:host,guest:host"'
@settings['ports'].each  do |hostname,forwards|
  @settings['ports'][hostname] = []
  forwards.split(/,/).each do |forward|
    guest, host = forward.split(/:/)
    @settings['ports'][hostname] << {'guest'=>guest, 'host'=>host}
  end
end
