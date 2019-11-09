#!/bin/env bash
#
# batterychk.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-07-06
#
# Displays the current charge of the battery, and a simple icon
# Requires:
#	-acpi
#	-notify-send
#	-FontAwesome

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Clear memory
usv() { unset _str_status _int_charge _str_mode _pth_prev _str_output; }

# Get Capacity Icon
getIcon() {
	local trv="0"										# This return value
	if [ -n "${1}" ]; then									# Only get an icon if a value is passed
		if [ "${1}" -ge 0 ]; then trv=""; fi						# 0-10%
		if [ "${1}" -ge 11 ]; then trv=""; fi						# 11-25%
		if [ "${1}" -ge 26 ]; then trv=""; fi						# 26-50%
		if [ "${1}" -ge 51 ]; then trv=""; fi						# 51-75%
		if [ "${1}" -ge 76 ]; then trv=""; fi						# 76-100%
	fi
	echo "${trv}"										# Return $trv
}

# Desktop Notification -- Args: $1: Priority; $2: Message
notify() {
	if [ -n "${2}" ]; then
		case "${1}" in
			0 )	notify-send -u low "${2}";;					# Low Priority
			1 )	notify-send -u normal "${2}";;					# Normal Priority
			2 )	notify-send -u critical "${2}";;				# Critical Priority
		esac
	fi
}

# ##------------------------------------##
# #		Variables		|#
# ##------------------------------------##
_str_status=""											# ACPI Battery Status
_int_charge=""											# Battery Charge/Capacity
_str_mode=""											# Battery Mode
_pth_prev="${HOME}/.cache/scripts/batterychk/state"						# Previous battery state
_str_output=""											# Output String

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
_str_status="$(acpi -b | sed 's/,//g')"								# Get Battery Status
_int_charge="$(echo "${_str_status}" | cut -f4 -d' ' | sed 's/%//')"				# Get Battery Charge
_str_mode="$(echo "${_str_status}" | cut -f3 -d' ')"						# Get Battery Mode
_str_output="$(getIcon "${_int_charge}")  ${_int_charge}"					# Get Output String
if acpi -a | grep -qi "on"; then _str_output="  ${_str_output}"; fi				# If charging, add AC icon
if [ ! -d "$(dirname "${_pth_prev}")" ]; then mkdir -p "$(dirname "${_pth_prev}")"; fi		# Make Previous-State directory
if [ -f "${_pth_prev}" ]; then									# If Previous-State saved
	_str_prev="$(cat "${_pth_prev}")"							# Get Previous-State into a var
	if [[ "${_str_prev,,}" != "${_str_mode,,}" ]]; then					# If Previous-State && Current-State are different
		notify "1" "${_str_output:2} ${_str_mode}"					# Send desktop notification for change-of-state
	fi
	printf '%s\n' "${_str_mode,,}" > "${_pth_prev}"						# Write current state to prev-state file
	unset _str_prev										# Clear Memory
else												# Otherwise
	printf '%s\n' "${_str_mode,,}" > "${_pth_prev}"						# Write current state to prev-state file
fi
printf '%s\n' "${_str_output}"									# Output current status
usv
