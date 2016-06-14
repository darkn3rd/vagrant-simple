# -*- mode: ruby -*-
# vi: set ft=ruby :

############### GET CURRENT TIME
@time = Time.now.strftime("%Y%m%d%H%M%S")
############### BUILD RUBY DATA STRUCTURE (HoHoLoH)
require 'nori'
parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_s })
xml = open(CONFIGFILE).read
@settings = parser.parse(xml)['settings'] # retreive * under parent element
