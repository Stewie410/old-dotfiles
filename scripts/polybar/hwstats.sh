#!/bin/env bash
#
# hwstats.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-02
#
# Reports Current:
#	-Average CPU Temperature
#	-CPU Frequency
#	-RAM Utilization
# Requires:
#	-lm_sensors
#	-cpupower
#	-qalc

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() { unset _output_icon _output_units _output_sep; }

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_output_icon}" ]; then printErr "null" "_output_icon"; return 1; fi
	if [ -z "${_output_units}" ]; then printErr "null" "_output_units"; return 1; fi
	if [ -z "${_output_sep}" ]; then printErr "null" "_output_sep"; return 1; fi

	# Check for required packages/commands
	if ! command -v sensors >/dev/null 2>&1; then printErr "pkg" "sensors"; return 1; fi
	if ! command -v cpupower >/dev/null 2>&1; then printErr "pkg" "cpupower"; return 1; fi
	if ! command -v qalc >/dev/null 2>&1; then printErr "pkg" "qalc"; return 1; fi
	
	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if no args passed
	local _msg										# Error Message
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Undefined Variable
		pkg )	_msg="Cannot locate package/command";;					# Missing Package
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Get CPU Temperature
getTemperature() {
	sensors --no-adapter | \
		awk --assign=COUNT="$(sensors | sed -n '/^Core/p' | wc --lines)" '/^Core/ {SUM += $3} END {print SUM/COUNT}' | \
		xargs printf '%.*f\n' 2
}

# Get CPU Frequency
getFrequency() { cpupower frequency-info --freq --human | awk 'END {print $4,$5}'; }

# Get RAM Utilization
getMemoryUtilization() { free | awk '/^Mem/ {print $2/$3}' | xargs printf '%.*f\n' 2; }

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Output Strings
_output_icon=""
_output_units="°C"
_output_sep="  "

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then return 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Print Stats
printf "${_output_icon} %s${_output_sep}%s${_output_sep}%s\n" "$(getTemperature)${_output_units}" "$(getFrequency)" "$(getMemoryUtilization)%"
