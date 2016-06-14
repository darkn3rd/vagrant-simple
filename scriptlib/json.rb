# -*- mode: ruby -*-
# vi: set ft=ruby :

############### GET CURRENT TIME
@time = Time.now.strftime("%Y%m%d%H%M%S")
############### BUILD RUBY DATA STRUCTURE (HoHoLoH)
require 'json'
json = open(CONFIGFILE).read
@settings = JSON.parse(json)
