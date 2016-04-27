#!/bin/sh
[ -e config.txt ] || touch config.txt
echo "Client Configuration on $(date "+%Y-%m-%d %H:%M:%S")" >> config.txt
