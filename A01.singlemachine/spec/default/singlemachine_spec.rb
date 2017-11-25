require 'spec_helper'

# Test Configuratiosn from Provisioning
describe 'Provisioning Script Tests' do
  describe ppa('dawidd0811/neofetch-daily') do
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
describe 'Vagrantfile Configuration Tests' do
  describe interface('eth1') do
    it { should have_ipv4_address('192.168.53.72') }
  end

  describe host('myworkstation.dev') do
    its(:ipaddress) { should eq '127.0.0.1' }
    it { should be_resolvable.by('hosts') }
  end
end

# Test Vagrant Image
describe 'Vagrant Image Tests' do
  describe user('vagrant') do
    it { should exist }
    it { should belong_to_group 'vagrant' }
  end
end
