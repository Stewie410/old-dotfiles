#!/bin/env bash
#
# batterychk.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-10-26
#
# Displays the current charge of the battery with an icon
# Requires:
#	-acpi
#	-notify-send
#	-FontAwesome

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() {
	unset _path_file_previous
	unset _icon_ac _icon_0 _icon_25 _icon_50 _icon_75 _icon_100
	unset _output_charge _output_mode _output_icon _output_string
}

# Check Options
checkOpts() {
	# Check for null variables
	if [ -z "${_path_file_previous}" ]; then printErr "null" "_path_file_previous"; return 1; fi
	if [ -z "${_icon_ac}" ]; then printErr "null" "_icon_ac"; return 1; fi
	if [ -z "${_icon_0}" ]; then printErr "null" "_icon_0"; return 1; fi
	if [ -z "${_icon_25}" ]; then printErr "null" "_icon_25"; return 1; fi
	if [ -z "${_icon_50}" ]; then printErr "null" "_icon_50"; return 1; fi
	if [ -z "${_icon_75}" ]; then printErr "null" "_icon_75"; return 1; fi
	if [ -z "${_icon_100}" ]; then printErr "null" "_icon_100"; return 1; fi
	if [ -z "${_output_charge}" ]; then printErr "null" "_output_charge"; return 1; fi
	if [ -z "${_output_mode}" ]; then printErr "null" "_output_mode"; return 1; fi
	if [ -z "${_output_icon}" ]; then printErr "null" "_output_icon"; return 1; fi
	if [ -z "${_output_string}" ]; then printErr "null" "_output_string"; return 1; fi

	# Check for existence of Directories
	if [ ! -d "${_path_file_previous%\/*}" ]; then mkdir -p "${_path_file_previous%\/*}"; fi
	
	# Check for existence of Files
	if [ ! -f "${_path_file_previous}" ]; then printf '%s\n' "${_output_mode}" > "${_path_file_previous}"; fi

	# Check for required packages
	if ! command -v acpi >/dev/null 2>&1; then printErr "pkg" "acpi"; return 1; fi
	if ! command -v notify-send >/dev/null 2>&1; then printErr "pkg" "notify-send"; return 1; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	local _msg										# Error Message
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Undefined Variable
		pkg )	_msg="Required package/command is missing";;				# Missing Package
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Get Capacity Icon -- Args: $1: Charge Capacity (%)
getIcon() {
	if [ -z "${1}" ]; then return; fi							# Break if no args passed
	local _ico										# Icon to return
	if ((${1} >= 0)) && ((${1} <= 10)); then _ico="${_icon_0}"; fi				# 0-10
	if ((${1} > 10)) && ((${1} <= 25)); then _ico="${_icon_25}"; fi				# 11-25
	if ((${1} > 25)) && ((${1} <= 50)); then _ico="${_icon_50}"; fi				# 26-50
	if ((${1} > 50)) && ((${1} <= 75)); then _ico="${_icon_75}"; fi				# 51-75
	if ((${1} > 75)) && ((${1} <= 100)); then _ico="${_icon_100}"; fi			# 76-100
	echo "${_ico}"										# Return Icon
}

# Notify User -- Args: $1: Priority; $2: Message
notify() {
	if [ -z "${2}" ]; then return; fi							# Break if no args passed
	local _pri										# Priority
	case "${1}" in
		0 )	_pri="low";;								# Low Priority
		1 )	_pri="normal";;								# Normal Priority
		2 )	_pri="ciritical";;							# Critical Priority
		* )	_pri="ERROR";;								# Unrecognized
	esac
	notify-send -u "${_pri}" "${2}"								# Send Notification
}

# Get Battery Charge
getCharge() { acpi --battery | sed 's/,//g;s/%//' | cut --delimiter=' ' --fields=4; }

# Get Battery State
getMode() { acpi --battery | sed 's/,//g' | cut --delimiter=' ' --fields=3; }

# Determine if AC Adapter is connected
adapterConnected() {
	if acpi --ac-adapter | grep --quiet --ignore-case "on"; then return 0; fi
	return 1
}

# Determine if current and previous states are the same
stateSame() {
	if [[ "$(cat "${_path_file_previous}")" != "${_output_mode}" ]]; then
		printf '%s\n' "${_output_mode}" > "${_path_file_previous}"
		return 1
	fi
	return 0
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Paths -- Files
_path_file_previous="${HOME}/.cache/scripts/batterychk/state"					# Previous battery state

# Icons
_icon_ac=""											# Charging Icon
_icon_0=""											# Critically Low Icon
_icon_25=""											# 25% Battery
_icon_50=""											# 50% Battery
_icon_75=""											# 75% Battery
_icon_100=""											# 100% Battery

# Output Strings
_output_charge="$(getCharge)"									# Battery Charge
_output_mode="$(getMode)"									# Charging/Discharging Mode
_output_icon="$(getIcon "${_output_charge}")"							# Battery Icon
_output_string="${_output_icon} ${_output_charge}"						# Output String

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then return 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Add icon for charging
if adapterConnected; then _output_string="${_icon_ac} ${_output_string}"; fi			# If AC Adapter is connected, add charging icon

# Notify User
if ! stateSame; then notify "1" "${_output_string} ${_output_mode}"; fi				# Notify user if state has changed

# Print Status
printf '%s\n' "${_output_string}"
