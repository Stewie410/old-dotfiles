#!/usr/bin/env bash
#
# xbrightness.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
#
# Wrapper for brightnessctl

# ##----------------------------##
# #| 		Traps 		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #| 		Functions 		|#
# ##------------------------------------##
# Cleanup
usv() {
	# Print & Notify current brightness
	[ -n "${flag}" ] && notify "$(brGet)"

	# Clear Memory
	unset valSet valChange valCurrent oSet oInc oDec OPTS
}

# Check Options
checkOpts() {
	# Check Variables
	[ -n "${valSet}" ] || { printErr "null" "valSet"; return 1; }
	[ -n "${valChange}" ] || { printErr "null" "valChange"; return 1; }
	[ -n "${oSet}" ] || { printErr "null" "oSet"; return 1; }
	[ -n "${oInc}" ] || { printErr "null" "oInc"; return 1; }
	[ -n "${oDec}" ] || { printErr "null" "oDec"; return 1; }

	# Check required commands
	command -v brightnessctl >/dev/null || { printErr "pkg" "brightnessctl"; return 1; }

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	# Return if no args passed
	[ -n "${2}" ] || return

	# Determine message
	local _msg
	case "${1,,}" in
		null ) 	_msg="Variable is undefined";;
		pkg ) 	_msg="Cannot locate required command";;
		* ) 	_msg="An unexpected error occurred";;
	esac

	# Print Message
	printf 'ERROR:\t%s:\t%s\n' "${_msg}" "${2}"
}

# Show Help
show_help() {
	cat << EOF
xbrightness.sh [options]

Wrapper for Brightnessctl

Options:
	-h, --help 			Show this help message
	-i, --increase <int> 		Increase brightness by the given amount (%)
	-d, --decrease <int> 		Decrease brightness by the given amount (%)
	-s, --set <int> 		Set brightness to the given value (%)
EOF
}

# Send Notification -- Args: $1: Brightness Value
notify() {
	# Define Message
	local msg
	msg="Brightness: ${1}%"

	# Print Message
	printf '%s\n' "${msg}"

	# Send Desktop Notification
	command -v notify-send >/dev/null && notify-send --urgency="normal" "${msg}"
}

# Get Brightness Level
brGet() { brightnessctl info | awk '/%/ {print $NF}' | sed 's/[^0-9]//g'; }

# ##------------------------------------##
# #| 		Variables 		|#
# ##------------------------------------##
# Options
valSet="100"
valChange="5"
valCurrent=""

# Options
oSet="0"
oInc="0"
oDec="0"

# ##--------------------------------------------##
# #| 		Handle Arguments 		|#
# ##--------------------------------------------##
OPTS="$(getopt --options hgs:i:d: --longoptions help,get,set:,increase:,decrease: --name "xbrightness.sh" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help ) 		show_help; exit 0;;
		-g | --get ) 		oSet="0"; oInc="0"; oDec="0"; shift;;
		-s | --set ) 		oSet="1"; oInc="0"; oDec="0"; valSet="${2}"; shift 2;;
		-i | --increase ) 	oSet="0"; oInc="1"; oDec="0"; valChange="${2}"; shift 2;;
		-d | --decrease ) 	oSet="0"; oInc="0"; oDec="1"; valChange="${2}"; shift 2;;
		-- ) 			shift; break;;
		* ) 			break;;
	esac
done

# ##------------------------------------##
# #| 		Pre-Run Tasks 		|#
# ##------------------------------------##
# Check Options
checkOpts || exit 1

# Get Current Brightness
valCurrent="$(brGet)"

# ##----------------------------##
# #| 		Run 		|#
# ##----------------------------##
# Modify Brightness
((oSet)) && brightnessctl --quiet set "${valSet}%" && flag="1"
((oInc)) && brightnessctl --quiet set "${valChange/%/}%+" && flag="1"
((oDec)) && brightnessctl --quiet set "${valChange/%/}%-" && flag="1"
