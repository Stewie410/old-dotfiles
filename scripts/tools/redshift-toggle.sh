#!/bin/env bash
#
# redshift-toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-03
#
# Toggles Redshift
# Usage:	redshift-toggle.sh [location]

# Kill Redshift if running
if pgrep --exact "redshift"; then killall --quiet "redshift"; exit; fi

# If location passed
if [ -n "${1}" ]; then
	if ! [[ "${1}" =~ ^[+-]?[0-9.]+:[+-]?[0-9.]+$ ]]; then
		printf '%s\n' "ERROR: Requires Lat:Lon for location input"
		exit 1
	fi
	redshift -l "${1}" & disown
	exit
fi

# Guess location by default
redshift -l "geoclue2" & disown
