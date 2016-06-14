#!/bin/sh
[ -e config.txt ] || touch config.txt
echo "Slave Configuration on $(date "+%Y-%m-%d %H:%M:%S")" >> config.txt
