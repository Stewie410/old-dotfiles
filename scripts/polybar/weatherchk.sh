#!/bin/env bash
#
# weatherchk.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-01
#
# Get the the weather right now, and tomorrow
# Requres:
#	-curl

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() { unset _opt_icon _opt_temp _opt_wind _opt_prec; }

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_opt_icon}" ]; then printErr "null" "_opt_icon"; return 1; fi
	if [ -z "${_opt_temp}" ]; then printErr "null" "_opt_temp"; return 1; fi
	if [ -z "${_opt_wind}" ]; then printErr "null" "_opt_wind"; return 1; fi
	if [ -z "${_opt_prec}" ]; then printErr "null" "_opt_prec"; return 1; fi
	
	# Normalize Options
	if ((_opt_icon < 0)); then _opt_icon="0"; elif ((_opt_icon > 1)); then _opt_icon="1"; fi
	if ((_opt_temp < 0)); then _opt_temp="0"; elif ((_opt_temp > 1)); then _opt_temp="1"; fi
	if ((_opt_wind < 0)); then _opt_wind="0"; elif ((_opt_wind > 1)); then _opt_wind="1"; fi
	if ((_opt_prec < 0)); then _opt_prec="0"; elif ((_opt_prec > 1)); then _opt_prec="1"; fi

	# Check if online
	if isOffline; then return 1; fi
	
	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if no args passed
	local _msg
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Null value
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Message
}

# Check for network connectivity
isOffline() { ping -c 1 "8.8.8.8" 2>&1 | grep --ignore-case --quiet "uncreachable"; }

# Get Weather String
getWeather() {
	local _fmt										# Declare local variables
	if ((_opt_icon)); then _fmt="%c"; else _fmt="%C"; fi					# Get Condition Type
	if ((_opt_temp)); then _fmt+="+%t"; fi							# Include Temperature
	if ((_opt_wind)); then _fmt+="+%w"; fi							# Include Wind
	if ((_opt_prec)); then _fmt+="+%o"; fi							# Get precipication chance
	curl --silent --fail "wttr.in/?u&format=${_fmt}"					# Get Weather String
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Options
_opt_icon="0"											# Get Condition Icon or Text
_opt_temp="1"											# Get Temperature
_opt_wind="0"											# Get Wind
_opt_prec="0"											# Get Chance for Precipitation

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then printf '%s\n' ""; exit 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Get Weather String
getWeather
