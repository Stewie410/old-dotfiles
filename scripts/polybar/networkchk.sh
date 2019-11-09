#!/bin/env bash
#
# networkchk.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-10-26
#
# Check for a network connection on:
#	-Ethernet Adapters
#	-Wireless Adapters
#		-WiFi
#		-Bluetooth
# Requires:
#	-bluez (blueman)
#	-getopt
#	-systemd (systemctl)

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() {
	unset _icon_wifi _icon_ethernet _icon_bluetooth _icon_none
	unset _ip_test
	unset _output_sep _output_string
	unset OPTS
}

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_icon_wifi}" ]; then printErr "null" "_icon_wifi"; return 1; fi
	if [ -z "${_icon_ethernet}" ]; then printErr "null" "_icon_ethernet"; return 1; fi
	if [ -z "${_icon_bluetooth}" ]; then printErr "null" "_icon_bluetooth"; return 1; fi
	if [ -z "${_icon_none}" ]; then printErr "null" "_icon_none"; return 1; fi
	if [ -z "${_ip_test}" ]; then _ip_test="8.8.8.8"; fi
	if [ -z "${_output_sep}" ]; then printErr "null" "_output_sep"; return 1; fi

	# Check for existence of packages/commands
	if ! command -v systemctl >/dev/null 2>&1; then printErr "pkg" "systemd"; return 1; fi
	if ! command -v getopt >/dev/null 2>&1; then printErr "pkg" "getopt"; return 1; fi
	if [ ! -f "/usr/lib/systemd/system/bluetooth.service" ]; then printErr "pkg" "bluez"; return 1; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	local _msg										# Error Message
	case "${1,,}" in
		null )	_msg="Varable is undefined";;						# Undefined Variable
		pkg )	_msg="Required Package is missing";;					# Missing Package
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Show Help
show_help() {
	printf '%b\n' "networkchk.sh [Options]\nShow/Hide Glyphs to display what NICS are active\n" "Options:"
	printf '\t%s\t\t\t%s\n' "-h, --help" "Show this help message"
	printf '\t%s\t\t\t%s\n' "-b, --bluetooth" "Toggle the Bluetooth Service"
	printf "\n"
}

# Get Icon -- Args: $1: Type (opt)
getIcon() {
	local _ico										# Icon to return
	case "${1,,}" in
		eth )	_ico="${_icon_ethernet}";;						# Ethernet Icon
		wlp )	_ico="${_icon_wifi}";;							# Wifi Icon
		bth )	_ico="${_icon_bluetooth}";;						# Bluetooth Icon
		* )	_ico="${_icon_none}";;							# No-Network Icon
	esac
	echo "${_ico}"										# Return Icon
}

# Determine if there's an ethernet network connection
isEthernet() {
	ip route get "${_ip_test}" 2>&1 | \
		grep --fixed-strings "${_ip_test}" | \
		cut --delimiter=' ' --fields=5 | \
		grep --quiet --ignore-case --extended-regexp "^e"
}

# Determine if there's a wifi network connection
isWifi() {
	ip route get "${_ip_test}" 2>&1 | \
		grep --fixed-strings "${_ip_test}" | \
		cut --delimiter=' ' --fields=5 | \
		grep --quiet --ignore-case --extended-regex "^w"
}

# Determine if Bluetooth is enabled
isBluetooth() { systemctl is-active "bluetooth.service" | grep --quiet --line-regexp "active"; }

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Icons
_icon_wifi=""											# Wifi Icon
_icon_ethernet=""										# Ethernet Icon
_icon_bluetooth=""										# Bluetooth Icon
_icon_none="X"											# No-Network Icon

# IP Address
_ip_test="8.8.8.8"										# IP Address to test connections

# Output Strings
_output_sep=" "											# Seperator
_output_string=""										# Output String

# ##--------------------------------------------##
# #|		Handle Arguments		|#
# ##--------------------------------------------##
OPTS="$(getopt --options hb --longoptions help,bluetooth --name 'networkchk' -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help )		show_help; return 0;;
		-b | --bluetooth )
					if systemctl --state=active | grep --quiet "bluetooth.service"; then
						systemctl stop bluetooth
						break
					fi
					systemctl start bluetooth
					break
					;;
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
# Build Output String
if isEthernet; then _output_string+="$(getIcon "eth")${_output_sep}"; fi			# Add Ethernet Icon to string
if isWifi; then _output_string+="$(getIcon "wlp")${_output_sep}"; fi				# Add Wifi Icon to String
if isBluetooth; then _output_string+="$(getIcon "bth")"; fi					# Add Bluetooth Icon

# Print Network Status
printf '%s\n' "${_output_string}"
