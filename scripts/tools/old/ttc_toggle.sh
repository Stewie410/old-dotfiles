#!/bin/bash
#
# ttc_toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-02-19
#
# Toggle the tap-to-click functionality of the touchpad

# Functions
# Clear Memory
usv() { unset curstate tostate xinpid propid; }

# Check Options
checkOpts() {
	rv="0"		# Return Value

	# Check for definitions
	if [ "$rv" -eq 0 ] && [ -z "$xinpid" ]; then echo "Error, Device ID not set"; rv="1"; fi
	if [ "$rv" -eq 0 ] && [ -z "$tostate" ]; then echo "Error, State not set"; rv="1"; fi
	if [ "$rv" -eq 0 ] && [ -z "$propid" ]; then echo "Error, Propery ID not set"; rv="1"; fi

	# Check for "good" input
	if [ "$rv" -eq 0 ] && [ "$xinpid" -lt 0 ]; then echo "Bad Device ID: $xinpid"; rv="1"; fi
	if [ "$rv" -eq 0 ] && [ "$propid" -lt 0 ]; then echo "Bad Property ID: $propid"; rv="1"; fi
	if [ "$rv" -eq 0 ] && [ "$tostate" -lt 0 ]; then echo "Bad State: $tostate"; rv="1"; fi
	if [ "$rv" -eq 0 ] && [ "$tostate" -gt 1 ]; then echo "Bad State: $tostate"; rv="1"; fi
	
	# Return $rv
	echo "$rv"
}

# Show Help
show_help() {
	echo -e "Usage:\tttc_toggle.sh [Options]"
	echo -e "\t-h, --help\t\t\tShow this help message"
	echo -e "\t-i, --id\t<id>\t\tSpecify the Device ID"
	echo -e "\t-s, --state\t<num>\t\tEnable/Disable Propery"
	echo -e "\t-p, --prop\t<num>\t\tProperty Number"
	echo
}

# Vars
curstate=""		# Current State
tostate=""		# Change to this state
xinpid="12"		# xinput Device ID
propid="278"		# xinput Property ID

# Handle args
OPTS=$(getopt -o hi:s:p: --long help,id:,state:,prop: -n 'ttc_toggleArgs' -- "$@")
eval set -- "$OPTS"
while true; do
	case "$1" in
		-h | --help )		show_help; usv; return 0;;
		-i | --id )		xinpid="$2"; shift; shift;;
		-s | --state )		tostate="$2"; shift; shift;;
		-p | --prop )		propid="$2"; shift; shift;;
		-- )			shift; break;;
		* )			break;;
	esac
done

# Check Arguments
if [ "$(checkOpts)" -ne 0 ]; then usv; return 1; fi

# Run
# Get current state
curstate="$(xinput list-props "$xinpid" | awk "/$xinpid/ {print $NF}")"

# Change state
xinput set-prop "$xinpid" "$propid" "$tostate"

# Clear memory
usv
