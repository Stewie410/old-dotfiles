#!/bin/env bash
#
# weatherchk.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-02-20
#
# Get the the weather right now, and tomorrow from wttr.in

# Return if offline
ping -c 1 "8.8.8.8" |& grep --quiet --ignore-case "unreachable" && { printf "\n"; exit; }

# Print Weather
curl --silent --fail "wttr.in/?u&format=%C+%t" | sed 's/+//'
#curl --silent --fail "wttr.in/?u&format=%C+%t+%o" | sed 's/+//'
