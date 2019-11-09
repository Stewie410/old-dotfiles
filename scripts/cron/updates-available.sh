#!/bin/env bash
#
# updates-available.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-02
#
# Check for available system updates
# Pushes both desktop notifications && Polybar IPC messages
# Requires
#	-getopt
#	-notify-send
#	-polybar && polybar-msg
#	-yay

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() {
	unset _polybar_module _polybar_hook _polybar_bar
	unset _pkg_count
	unset _opt_notify _opt_polybar
	unset OPTS
}

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_polybar_module}" ]; then printErr "null" "_polybar_module"; return 1; fi
	if [ -z "${_polybar_hook}" ]; then printErr "null" "_polybar_hook"; return 1; fi
	if [ -z "${_polybar_bar}" ]; then printErr "null" "_polybar_bar"; return 1; fi
	if [ -z "${_pkg_count}" ]; then printErr "null" "_pkg_count"; return 1; fi
	if [ -z "${_opt_notify}" ]; then printErr "null" "_opt_notify"; return 1; fi
	if [ -z "${_opt_polybar}" ]; then printErr "null" "_opt_polybar"; return 1; fi
	
	# Normalize Options
	if ((_opt_notify < 0)); then _opt_notify="0"; elif ((_opt_notify > 1)); then _opt_notify="1"; fi
	if ((_opt_polybar < 0)); then _opt_polybar="0"; elif ((_opt_polybar > 1)); then _opt_polybar="1"; fi

	# Check for network connectivity
	if ping -c 1 "8.8.8.8" 2>&1 | grep --quiet --ignore-case "unreachable"; then printErr "net" "No network connection"; return 1; fi

	# Check for required packages/commands
	if ! command -v getopt >/dev/null 2>&1; then printErr "pkg" "getopt"; return 1; fi
	if ! command -v yay >/dev/null 2>&1; then printErr "pkg" "yay"; return 1; fi
	if ((_opt_notify)) && ! command -v notify-send >/dev/null 2>&1; then printErr "pkg" "notify-send"; return 1; fi
	if ((_opt_polybar)) && ! command -v polybar >/dev/null 2>&1; then printErr "pkg" "polybar"; return 1; fi
	if ((_opt_polybar)); then
		if ! command -v polybar >/dev/null 2>&1; then printErr "pkg" "polybar"; return 1; fi
		if ! command -v polybar-msg >/dev/null 2>&1; then printErr "pkg" "polybar-msg"; return 1; fi
	fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args are not passed
	local _msg
	case "${1,,}" in
		null )	_msg="Variable is not defined";;					# Null variable
		net )	_msg="Network Connection Error";;					# Network Connection
		pkg )	_msg="Cannot locate required package/command";;				# Missing Package/Command
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Errors
}

# Show Help
show_help() {
	printf '%b\n' "updates-avaiable.sh [Options]" "Gets the total number of available packages, and" "pushes Polybar IPC & Desktop notifications\n" "Options:"
	printf '\t%s\t\t\t%s\n' "-h, --help" "Show this help message"
	printf '\t%s\t\t\t%s\n' "-n, --notify" "Enable desktop notifications"
	printf '\t%s\t\t\t%s\n' "-p, --polybar" "Enable Polybar IPC messaging"
	printf '\t%s\t<str>\t%s\n' "-m, --polybar-module" "Define the polybar module name for IPC"
	printf '\t%s\t<int>\t%s\n' "-h, --polybar-hook" "Define the polybar module hook for IPC"
	printf '\t%s\t<str>\t%s\n' "-b, --polybar-bar" "Define the specified polybar bar name"
	printf "\n"
}

# Get Number of available packages
getPackageCount() { yay -Qu | wc --lines; }

# Notify User -- Args: $1: Number of Packages
notify() {
	if [ -z "${1}" ]; then return; fi							# Break if args are not passed
	local _priority										# Declare local variables
	_priority="low"										# Default priority: low
	if ((${1} >= 100)); then _priority="normal"; fi						# 100+: normal
	if ((${1} >= 200)); then _priority="critical"; fi					# 200+: critical
	notify-send --urgency="${_priority}" "${1} Packages Available"				# Send Notification
}

# Send Polybar IPC Message
ipcPolybar() {
	local _pid										# Declare local variables
	_pid="$(ps aux | grep "polybar ${_polybar_bar}" | grep --invert-match "grep" | awk '{print $2}')"	# Get the PID of the specified bar
	polybar-msg -p "${_pid}" hook "${_polybar_module}" "${_polybar_hook}" >dev/null 2>&1	# Send IPC Message
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Polybar IPC
_polybar_module="updates"									# Polybar IPC Module Name
_polybar_hook="2"										# Polybar IPC Module Hook
_polybar_bar="topbar"										# Polybar Bar Name

# Number of Packages
_pkg_count="0"											# Available Package Count

# Options
_opt_notify="0"											# Enable notifications for this run
_opt_polybar="0"										# Enable Polybar IPC Updates for this run

# ##--------------------------------------------##
# #|		Handle Arguments		|#
# ##--------------------------------------------##
OPTS="$(getopt --options hnpam:b: --longoptions help,notify,polybar,all,polybar-module:,polybar-hook:,polybar-bar: --name "updates-available" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help )		show_help; exit;;
		-n | --notify )		_opt_notify="1"; shift;;
		-p | --polybar )	_opt_polybar="1"; shift;;
		-a | --all )		_opt_notify="1"; _opt_polybar="1"; shift;;
		-m | --polybar-module )	_polybar_module="${2}"; shift 2;;
		--polybar-hook )	_polybar_hook="${2}"; shift 2;;
		-b | --polybar-bar )	_polybar_bar="${2}"; shift 2;;
		-- )			shift; break;;
		* )			break;;
	esac
done

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then exit; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Get number of available package updates
_pkg_count="$(getPackageCount)"

# If count is > 0, push notifications
if ((_pkg_count)); then
	# Show Desktop Notification
	if ((_opt_notify)); then notify "${_pkg_count}"; fi

	# Push Polybar IPC Message
	if ((_opt_polybar)); then ipcPolybar; fi
fi
