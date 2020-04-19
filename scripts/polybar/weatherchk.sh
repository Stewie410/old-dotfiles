#!/usr/bin/env bash
#
# weatherchk.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Get the the weather right now

# Print Weather
curl --silent --fail "wttr.in/?u&format=%C+%t" | sed 's/+//'
#curl --silent --fail "wttr.in/?u&format=%C+%t+%o" | sed 's/+//'
