#!/bin/bash
#
# pavolume.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-01-11
#
# Grab the current volume level, with varying icons

# Functions
# Get the relevant icon
getIcon() {
	if [ "$1" -ge 50 ]; then echo "";	# Volume High
	elif [ "$1" -ge 30 ]; then echo "";	# Volume Med
	elif [ "$1" -ge 1 ]; then echo "";	# Volume Low
	else echo ""; fi			# Mute
}

# Vars
vol=""						# Current Volume level
mut=""						# Current Mute Status
str=""						# Output String

# Handle Actions
if [ -n "$1" ]; then
	case "$1" in
		"x" | "X" )	pamixer --toggle-mute; ;;
		"+" )		pamixer --increase 1; ;;
		"-" )		pamixer --decrease 1; ;;
	esac
fi

# Update Vars
vol="$(pamixer --get-volume)"
mut="$(pamixer --get-mute)"

# Get output String
if [[ "$mut" == "true" ]]; then
	str="$(getIcon "0")"
else
	str="$(getIcon "$vol") $vol"
fi

# Report Status
echo "$str"

# Clear memory
unset vol mut str
