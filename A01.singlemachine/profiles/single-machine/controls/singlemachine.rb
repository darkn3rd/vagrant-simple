# encoding: utf-8
# copyright: 2017, The Authors

title 'Single Machine Tests'

control 'vagrant-provision' do
  title 'Provisioning Script Tests'             # A human-readable title
  desc 'Tests Provisioning Scripts applied to virtual guest'

  describe apt('dawidd0811/neofetch-daily') do
    it { should exist }
    it { should be_enabled }
  end

  describe package('neofetch') do
    it { should be_installed }
  end

  describe package('landscape-common') do
    it { should_not be_installed }
  end

  describe file('/etc/update-motd.d/20-neofetch') do
    it { should be_linked_to '/usr/bin/neofetch' }
    it { should be_executable }
  end
end

# Default Configurations From Vagrantfile
control 'vagrant-config' do
  title 'Vagrantfile Configuration Tests'             # A human-readable title
  desc 'Tests the Vagrant configuration specified in Vagrantfile'

  describe interface('eth1') do
    it { should exist }
  end

  describe command('ip -4 addr show eth1') do
    its('stdout') { should include('192.168.53.72') }
  end


  describe host('myworkstation.dev') do
    its('ipaddress') { should include '127.0.0.1' }
    it { should be_resolvable }
  end
end

# Test Vagrant Image
control 'vagrant-image' do
  title 'Vagrant Image Tests'             # A human-readable title
  desc 'Test the vagrant image requirements'
  describe user('vagrant') do
    it { should exist }
    its('groups') { should include('vagrant') }
  end
end
