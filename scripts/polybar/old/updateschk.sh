#!/bin/bash
#
# updateschk.sh
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-11-02
#
# Get the total number of available packages since last sync
# Requires:
#	yay

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() { unset ico cnt; }

# Check for network connection
isOffline() { ping -c 1 "8.8.8.8" | grep --quiet --ignore-case "unreachable"; }

# Notify User -- Args: ${1}: Package Count
notifyUser() {
	if [ -z "${1}" ]; then return; fi
	local _pri										# Declare local variables
	if ((${1} < 100)); then _pri="low";							# Low Priority
	elif ((${1} < 200)); then _pri="normal";						# Normal Priority
	else _pri="critical"; fi								# Critical Priority
	notify-send --urgency="${_pri}" "${1} Packages Available"				# Send Notification
}

# Get Count
getCnt() { yay -Sup | wc --lines; }

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
ico=""												# Icon to use
cnt=""												# Number of packages

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# If not connected, exit
if isOffline; then exit; fi

# Get Count
cnt="$(getCnt)"

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Notify based on ${cnt}
if ((cnt)); then notifyUser "${cnt}"; fi

# Print Number of Updates
printf '%b\n' "${ico} ${cnt}"
