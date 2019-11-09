#!/bin/bash
#
# redshift-toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-01-21
#
# Toggles Redshift on, or off; with a few commands

# Vars
loc=""				# Location

# Handle args
if [ -n "$1" ]; then
	if [[ "$1" =~ ^[aA] ]]; then loc="geoclue2";
	elif [[ "$1" =~ ^[mM] ]] && [ -n "$2" ]; then loc="$2"; fi
fi

# Toggle Redshift
if pgrep -x redshift; then
	killall -q redshift
elif [ -z "$loc" ]; then
	redshift -l geoclue2 & disown
else
	if [[ "$loc" =~ ^[aA] ]]; then
		redshift -l geoclue2 & disown
	else
		redshift -l "$loc" & disown
	fi
fi

# Clear memory
unset loc
