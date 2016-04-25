#!/bin/sh
[ -e config.txt ] || touch config.txt
echo "Slave2 Configuration on $(date "+%Y-%m-%d %H:%M:%S")" >> config.txt
