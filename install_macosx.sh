#!/bin/sh

# Check for Homebrew
command -v brew 2>&1 > /dev/null || { echo "ERROR: Homebrew Not Installed" 1>&2; exit 1;}
brew update
brew tap Homebrew/bundle
# Install Packages
brew bundle --verbose

# Install Vagrant Plugins
vagrant plugin install sqlite3
vagrant plugin install inifile

# Post Python Installations
brew linkapps python
pip install --upgrade pip setuptools

# Install Ansible
sudo -H pip install ansible
# Install Other Libraries
pip install requirements
