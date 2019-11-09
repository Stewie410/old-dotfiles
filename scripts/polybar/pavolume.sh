#!/bin/env bash
#
# pavolume.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-10-26
#
# Grab the current volume level & associated icon
# Requires:
#	-pamixer

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() { unset _icon_low _icon_medium _icon_high _icon_mute; }

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_icon_low}" ]; then printErr "null" "_icon_low"; return 1; fi
	if [ -z "${_icon_medium}" ]; then printErr "null" "_icon_medium"; return 1; fi
	if [ -z "${_icon_high}" ]; then printErr "null" "_icon_high"; return 1; fi
	if [ -z "${_icon_mute}" ]; then printErr "null" "_icon_mute"; return 1; fi

	# Check for missing packages/commands
	if ! command -v pamixer; then printErr "pkg" "pamixer"; return 1; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	local _msg										# Error Message
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Undefined Variables
		pkg )	_msg="Cannot locate package/command";;					# Missing Package/Command
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Get Icon -- Args: $1: Volume Level (opt)
getIcon() {
	local _ico										# Icon to return
	if ! ((${1})); then _ico="${_icon_mute}";						# Muted Volume
	elif ((${1} > 0)) && ((${1} <= 33)); then _ico="${_icon_low}";				# Low Volume
	elif ((${1} > 33)) && ((${1} <= 66)); then _ico="${_icon_medium}";			# Medium Volume
	elif ((${1} > 66)) && ((${1} <= 100)); then _ico="${_icon_high}"; fi			# High Volume
	echo "${_ico}"										# Return Icon
}

# Get Status String
getStatus() {
	local _vol _mute _out									# Local Vars
	_vol="$(pamixer --get-volume)"								# Volume Level
	if pamixer --get-mute | grep --ignore-case --quiet "true"; then _vol="0"; fi		# If Muted, set "volume" to 0
	_out="$(getIcon "${_vol}")"								# Add Icon to Output String
	if ((_vol)); then _out+=" ${_vol}"; fi							# Add volume level if greater than 0
	echo "${_out}"										# Return Output String
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Icons
_icon_low=""											# Low Volume Icon
_icon_medium=""										# Medium Volume Icon
_icon_high=""											# High Volume Icon
_icon_mute=""											# Muted Icon

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then return 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Print Status
printf '%s\n' "$(getStatus)"
