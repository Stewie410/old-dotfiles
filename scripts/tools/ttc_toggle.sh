#!/bin/env bash
#
# ttc_toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-03
#
# Toggle the TapToClick functionality of the touchpad
# Requires:
#	-xinput
#	-getopt

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() {
	unset _id_device _id_property
	unset _state_current _state_select
	unset OPTS
}

# Check Options
checkOpts() {
	# Check for null variables
	if [ -z "${_id_device}" ]; then printErr "null" "_id_device"; return 1; fi
	if [ -z "${_id_property}" ]; then printErr "null" "_id_property"; return 1; fi
	if [ -z "${_state_current}" ]; then printErr "null" "_state_current"; return 1; fi
	if [ -z "${_state_select}" ]; then printErr "null" "_state_select"; return 1; fi

	# Normalize State
	if ((_state_current < 0)); then _state_current="0"; elif ((_state_current > 1)); then _state_current="1"; fi
	if ((_state_select < 0)); then _state_select="0"; elif ((_state_select > 1)); then _state_select="1"; fi

	# Check for existence of packages/commands
	if ! command -v getopt >/dev/null 2>&1; then printErr "pkg" "getopt"; return 1; fi
	if ! command -v xinput >/dev/null 2>&1; then printErr "pkg" "xinput"; return 1; fi
	
	# Check Device ID
	if [[ "${_id_device}" =~ [^0-9] ]]; then printErr "id" "Invaid ID Format:\t${_id_device}"; return 1; fi
	if ! xinput --list --short | grep --quiet "${_id_device}"; then printErr "id" "Cannot locate device:\t${_id_device}"; return 1; fi

	# Check Property ID
	if [[ "${_id_property}" =~ [^0-9] ]]; then printErr "id" "Invalid ID Format:\t${_id_property}"; return 1; fi
	if ! xinput --list-props "${_id_device}" | grep --quiet "${_id_property}"; then printErr "id" "Cannot locate property:\t${_id_property}"; return 1; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	local _msg										# Declare local variables
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Null Variable
		pkg )	_msg="Cannot locate package/command";;					# Missing package/command
		id )	_msg="ID Error";;							# Dev/Prop ID
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Show Help
show_help() {
	printf '%b\n' "ttc_toggle.sh [Options]" "Toggles the Tap-To-Click functionality of the touchpad\n" "Options:"
	printf '\t%s\t\t\t%s\n' "-h, --help" "Show this help message"
	printf '\t%s\t<int>\t\t%s\n' "-d, --id-dev" "Define the device ID"
	printf '\t%s\t<int>\t\t%s\n' "-p, --id-prop" "Define the property ID"
	printf '\t%s\t<int>\t\t%s\n' "-s, --state" "Define the state to set the property to (0/1)"
	printf "\n"
}

# Get Device ID from xinput
getIDDevice() { 
	xinput --list --short | \
		sed --quiet '/touchpad/Ip' | \
		grep --invert-match --ignore-case "ps/2" | \
		awk '{print $6}' | \
		cut --fields=2 --delimiter='='
}

# Get Property ID from xinput -- Args: $1: Device ID
getIDProperty() {
	if [ -z "${1}" ]; then return; fi							# Break if args not passed
	xinput --list-props "${1}" | \
		sed -n '/tapping enabled/Ip' | \
		grep --invert-match --ignore-case "default" | \
		awk '{print $4}' | \
		sed 's/[^0-9]//g'
}

# Get Current State of Property -- Args: $1: Device ID; $2: Property ID
getState() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	xinput --list-props "${1}" | \
		grep "${2}" | \
		awk '{print $NF}'
}

# Set State of Property -- Args: $1: Device ID; $2: Property ID; $3: State
setState() {
	if [ -z "${3}" ]; then return; fi							# Break if args not passed
	xinput --set-prop "${1}" "${2}" "${3}"							# Set Property
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# IDs
_id_device="12"											# Device ID
_id_property="278"										# Property ID

# States
_state_current="0"										# Current State
_state_select="0"										# Selected State

# ##--------------------------------------------##
# #|		Handle Arguments		|#
# ##--------------------------------------------##
OPTS="$(getopt --options hd:p:s: --longoptions help,id-dev:,id-prop:,state: --name "ttc_toggle" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help )		show_help; exit;;
		-d | --id-dev )		_id_device="${2}"; shift 2;;
		-p | --id-prop )	_id_property="${2}"; shift 2;;
		-s | --state )		_state_select="${2}"; shift 2;;
		-- )			shift; break;;
		* )			break;;
	esac
done

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then exit 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Get Device ID
if [ -z "${_id_device}" ]; then _id_device="$(getIDDevice)"; fi

# Get Property ID
if [ -z "${_id_property}" ]; then _id_property="$(getIDProperty "${_id_device}")"; fi

# Get Current state
_state_current="$(getState "${_id_device}" "${_id_property}")"

# If Selected state is not set, get as opposite of current; if they are the same, exit
if [ -z "${_state_selected}" ]; then 
	_state_selected="$((! _state_current))"
elif ((_state_selected == _state_current)); then
	exit
fi

# Update Property State
setState "${_id_device}" "${_id_property}" "${_state_selected}"
