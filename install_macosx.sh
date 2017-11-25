#!/bin/sh

# Check for Homebrew
command -v brew 2>&1 > /dev/null || { echo "ERROR: Homebrew Not Installed" 1>&2; exit 1;}
brew update
# Install Packages
brew bundle --verbose

# Install Vagrant Plugins
vagrant plugin install sqlite3
vagrant plugin install inifile

# Post Python Installations
pip2 install --upgrade pip setuptools

# Install Ansible
sudo -H pip2 install ansible
# Install Other Libraries
pip2 install -r requirements.txt
