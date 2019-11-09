#!/bin/bash
#
# pactl.sh
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-10-26
#
# A wrapper for pamixer to do normal things (inc, dec, mute) with notifications
# Requires:
#	-getopt
#	-notify-send
#	-pamixer
#	-polybar-msg (if IPC requested)

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() { 
	unset _icon_mute _icon_umute _icon_increase _icon_decrease
	unset _polybar_module _polybar_hook _polybar_bar
	unset _amt_delta
	unset _opt_notify _opt_mute _opt_umute _opt_toggle _opt_increase _opt_decrease _opt_polybar
	unset OPTS
}

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_icon_mute}" ]; then printErr "null" "_icon_mute"; return 1; fi
	if [ -z "${_icon_umute}" ]; then printErr "null" "_icon_umute"; return 1; fi
	if [ -z "${_icon_increase}" ]; then printErr "null" "_icon_increase"; return 1; fi
	if [ -z "${_icon_decrease}" ]; then printErr "null" "_icon_decrease"; return 1; fi
	if [ -z "${_polybar_module}" ]; then printErr "null" "_polybar_module"; return 1; fi
	if [ -z "${_polybar_hook}" ]; then printErr "null" "_polybar_hook"; return 1; fi
	if [ -z "${_polybar_bar}" ]; then printErr "null" "_polybar_bar"; return 1; fi
	if [ -z "${_amt_delta}" ]; then printErr "null" "_amt_delta"; return 1; fi
	if [ -z "${_opt_notify}" ]; then printErr "null" "_opt_notify"; return 1; fi
	if [ -z "${_opt_mute}" ]; then printErr "null" "_opt_mute"; return 1; fi
	if [ -z "${_opt_umute}" ]; then printErr "null" "_opt_umute"; return 1; fi
	if [ -z "${_opt_toggle}" ]; then printErr "null" "_opt_toggle"; return 1; fi
	if [ -z "${_opt_increase}" ]; then printErr "null" "_opt_increase"; return 1; fi
	if [ -z "${_opt_decrease}" ]; then printErr "null" "_opt_decrease"; return 1; fi
	if [ -z "${_opt_polybar}" ]; then printErr "null" "_opt_polybar"; return 1; fi

	# Normalize Options
	if ((_opt_notify < 0)); then _opt_notify="0"; elif ((_opt_notify > 1)); then _opt_notify="1"; fi
	if ((_opt_mute < 0)); then _opt_mute="0"; elif ((_opt_mute > 1)); then _opt_mute="1"; fi
	if ((_opt_umute < 0)); then _opt_umute="0"; elif ((_opt_umute > 1)); then _opt_umute="1"; fi
	if ((_opt_toggle < 0)); then _opt_toggle="0"; elif ((_opt_toggle > 1)); then _opt_toggle="1"; fi
	if ((_opt_increase < 0)); then _opt_increase="0"; elif ((_opt_increase > 1)); then _opt_increase="1"; fi
	if ((_opt_decrease < 0)); then _opt_decrease="0"; elif ((_opt_decrease > 1)); then _opt_decrease="1"; fi
	if ((_opt_polybar < 0)); then _opt_polybar="0"; elif ((_opt_polybar > 1)); then _opt_polybar="1"; fi

	# Check Amount Delta
	if echo "${_amt_delta}" | grep --extended-regexp "[^0-9]"; then printErr "delta" "Inc/Dec Amount must be an integer"; return 1; fi
	if ((_opt_increase)) || ((_opt_decrease)); then
		if ((_amt_delta <= 0)); then printErr "delta" "Inc/Dec Amount must be greater than 0"; return 1; fi
	fi

	# Check for required packages/commands
	if ! command -v getopt >/dev/null 2>&1; then printErr "pkg" "getopt"; return 1; fi
	if ! command -v pamixer >/dev/null 2>&1; then printErr "pkg" "pamixer"; return 1; fi
	if ((_opt_notify)) && ! command -v notify-send >/dev/null 2>&1; then printErr "pkg" "notify-send"; return 1; fi
	if ((_opt_polybar)) && ! command -v polybar-msg >/dev/null 2>&1; then printErr "pkg" "polybar-msg"; return 1; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	local _msg										# Error message
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Undefined Variable
		delta )	_msg="Delta Error";;							# Amount Delta
		pkg )	_msg="Cannot locate required package/command";;				# Missing Package/Command
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Show Help
show_help() {
	printf '%b\n' "pactl.sh [Options]\nA wrapper for pamixer to inc/dec/mute volume + notifications\n" "Options:"
	printf '\t%s\t\t\t%s\n' "-h, --help" "Show this help message"
	printf '\t%s\t\t\t%s\n' "-n, --notify" "Notify the user"
	printf '\t%s\t\t\t%s\n' "-p, --polybar" "Send Polybar IPC Message"
	printf '\t%s\t\t\t%s\n' "-m, --mute" "Mute Volume"
	printf '\t%s\t\t\t%s\n' "-u, --umute" "Unmute Volume"
	printf '\t%s\t\t\t%s\n' "-t, --toggle" "Toggle Volume Mute"
	printf '\t%s\t\t<int>\t%s\n' "-i, --increase" "Increase the volume by a specified amount"
	printf '\t%s\t\t<int>\t%s\n' "-d. --decrease" "Decrease the volume by a specified amount"
	printf '\t%s\t<str>\t%s\n' "--polybar-module" "Define the polybar module name for IPC"
	printf '\t%s\t\t<int>\t%s\n' "--polybar-hook" "Define the polybar module hook for IPC"
	printf '\t%s\t\t<str>\t%s\n' "--polybar-bar" "Define the specified polybar bar name"
	printf "\n"
}

# Notify User -- Args: $1: Icon; $2: Message
notify() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	notify-send --urgency="normal" --icon="${1}" "${2}"					# Send notification
}

# Send Polybar IPC Message
ipcPolybar() {
	local _pid										# PID of specified bar
	_pid="$(ps aux | grep "polybar ${_polybar_bar}" | grep -v "grep" | awk '{print $2}')"	# Get PID of bar
	polybar-msg -p "${_pid}" hook "${_polybar_module}" "${_polybar_hook}" >/dev/null 2>&1	# Send IPC Message
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Icons
_icon_mute=""											# Mute Icon
_icon_umute=""											# Unmute Icon
_icon_increase=""										# Increase Vol Icon
_icon_decrease=""										# Decrease Vol Icon

# Polybar IPC
_polybar_module="pavolume"									# Polybar IPC Module Name
_polybar_hook="1"										# Polybar IPC Module Hook
_polybar_bar="topbar"										# Polybar Bar Name

# Volume Changes
_amt_delta="0"											# Amount to change

# Options
_opt_notify="0"											# Enable Notifications for this run
_opt_mute="0"											# Mute Volume
_opt_umute="0"											# Unmute Volume
_opt_toggle="0"											# Toggle Mute
_opt_increase="0"										# Increase Volume
_opt_decrease="0"										# Decrease Volume
_opt_polybar="0"										# Enable Polybar IPC Message

# ##--------------------------------------------##
# #|		Handle Arguments		|#
# ##--------------------------------------------##
OPTS="$(getopt --options hnpmuti:d: --longoptions help,notify,polybar,mute,unmute,toggle,increase:,decrease:,polybar-module:,polybar-hook:,polybar-bar: --name "pactl" -- "${@}")"
eval set -- "$OPTS"
while true; do
	case "$1" in
		-h | --help )		show_help; return;;
		-n | --notify )		_opt_notify="1"; shift;;
		-p | --polybar )	_opt_polybar="1"; shift;;
		-m | --mute )		_opt_mute="1"; _opt_umute="0"; shift;;
		-u | --unmute )		_opt_mute="0"; _opt_umute="1"; shift;;
		-t | --toggle )		_opt_toggle="1"; _opt_mute="0"; _opt_umute="0"; shift;;
		-i | --increase )	_opt_increase="1"; _opt_decrease="0"; _amt_delta="${2}"; shift 2;;
		-d | --decrease )	_opt_increase="0"; _opt_decrease="1"; _amt_delta="${2}"; shift 2;;
		--polybar-module )	_polybar_module="${2}"; shift 2;;
		--polybar-hook )	_polybar_hook="${2}"; shift 2;;
		--polybar-bar )		_polybar_bar="${2}"; shift 2;;
		-- )			shift; break;;
		* )			break;;
	esac
done

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then return 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
if ((_opt_mute)); then
	if pamixer --get-mute | grep --quiet --ignore-case "false"; then
		pamixer --mute
		if ((_opt_notify)); then notify "${_icon_mute}" "Muted"; fi
	fi
elif ((_opt_umute)); then
	if pamixer --get-mute | grep --quiet --ignore-case "true"; then
		pamixer --unmute
		if ((_opt_notify)); then notify "${_icon_umute}" "Unmuted"; fi
	fi
elif ((_opt_toggle)); then
	pamixer --toggle-mute
	if pamixer --get-mute | grep --quiet --ignore-case "true"; then
		if ((_opt_notify)); then notify "${_icon_mute}" "Muted"; fi
	elif pamixer --get-mute | grep --quiet --ignore-case "false"; then
		if ((_opt_notify)); then notify "${_icon_umute}" "Unmuted"; fi
	fi
elif ((_opt_increase)); then
	pamixer --increase "${_amt_delta}"
elif ((_opt_decrease)); then
	pamixer --decrease "${_amt_delta}"
fi
if ((_opt_polybar)); then ipcPolybar; fi
