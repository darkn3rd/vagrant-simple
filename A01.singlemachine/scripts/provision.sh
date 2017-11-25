#!/bin/sh

main() {
  install_neofetch
}

install_neofetch() {
  add-apt-repository ppa:dawidd0811/neofetch-daily
  apt-get update -qq
  apt-get install -y --no-install-recommends neofetch
}

main
