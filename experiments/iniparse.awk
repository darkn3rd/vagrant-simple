#!/usr/bin/env awk -f
# NAME: iniparse.awk
# AUTHOR: Joaquin Menchaca
# CREATED: 2016-04-24
#
# PURPOSE: Flatten INI files with section prepended like 'section.key=value'
# DEPENDENCIES:
#  * POSIX Awk (which includes GNU Awk)
!/^$/ {
  if ((start = index($0, "[")) != 0) {
      size = index(substr($0, start + 1), "]")
      section = substr($0, start+1, size-1)
  } else {
    print section "." $0
  }
}
