#!/bin/env bash
#
# spotifyctl.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-10-27
#
# Pulls current Artist & Title from Spotify
# Requires:
#	spotify
#	spotify-now

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() { unset _icon_spotify; }

# Check Options
checkOpts() {
	# Check for null variables
	if [ -z "${_icon_spotify}" ]; then printErr "null" "_icon_spotify"; return 1; fi

	# Check for required packages/commands
	if ! command -v spotify >/dev/null; then printErr "pkg" "spotify"; return 1; fi
	if ! command -v spotify-now >/dev/null; then printErr "pkg" "spotify-now"; return 1; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	local _msg										# Error message
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Null Variable
		pkg )	_msg="Required Package/Command is missing";;				# Missing Package/Command
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Get Artist & Track Title from Spotify
getStatus() {
	local _out										# Output String
	_out="$(spotify-now -i "%artist - %track")"						# Get Artist & Track title
	if [[ "${_out,,}" =~ ^ad(vert)? ]]; then _out="#Ad"; fi					# Handle advertisements
	echo "${_out}"
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Icons
_icon_spotify=""										# Spotify Icon

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then exit 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# If spotify isn't running, quit
if ! pgrep -x spotify >/dev/null; then printf '%s\n' ""; exit; fi

# Print Status
printf '%s\n' "${_icon_spotify} $(getStatus)"
