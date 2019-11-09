#!/bin/bash
#
# xrbrightness.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-02-03
#
# This is a workaround to adjust the gamma of eDP1 in lieu of xbacklight working
# as expected.

# Functions
# Clear Memory
usv() { unset inc dec amt ctr; }

# Incrememnt Brightness
ibr() {
	# Get current brightness
	cur="$(xrandr --current --verbose | awk '/Brightness/{print $2}')"
	nxt="$(calc -d "$cur + $1" | awk '{print $1}')"
	
	# If $cur < 1.0, then update brightness
	if [ "$(calc -d "$cur < 1.0" | awk '{print $1}')" -eq 1 ]; then
		xrandr --output eDP1 --brightness "$nxt"
	fi

	# Clear memory
	unset cur nxt
}

# Decrement Brightness
dbr() {
	# Get current brightness
	cur="$(xrandr --current --verbose | awk '/Brightness/{print $2}')"
	nxt="$(calc -d "$cur - $1" | awk '{print $1}')"

	# If $cur > 0.0, then update brightness
	if [ "$(calc -d "$cur > 0" | awk '{print $1}')" -eq 1 ]; then
		xrandr --output eDP1 --brightness "$nxt"
	fi

	# Clear memory
	unset cur nxt
}

# Show Help
show_help() {
	echo -e "Usage:\n\txrbrightness.sh [options]\n"
	echo -e "\t-h\t\t\tShow this Help Message"
	echo -e "\t-i\t\t\tIncrease Brightness"
	echo -e "\t-d\t\t\tDecrease Brightness"
	echo -e "\t-a <num>\t\tAmount to change Brightness"
	echo -e "\t\t\t\t\t0.0 < num < 1.0\n"
}

# Vars
inc="0.05"		# Increment Amount
dec="0.05"		# Decrement Amount
amt=""			# Temporary Amount
ctr=""			# Command To Run

# Handle Args
OPTIND=0
while getopts ":hida:" opt; do
	case "${opt}" in
		"h" )	show_help; usv; break;;
		"i" )	if [ -z "$ctr" ]; then ctr="inc"; fi;;
		"d" )	if [ -z "$ctr" ]; then ctr="dec"; fi;;
		"a" )	amt="${OPTARG}";;
		\?  )	echo "Error, invalid args!"; usv; break;;
	esac
done
shift $((OPTIND-1))

# Update $inc|$dec if $amt is defined
if [ -n "$amt" ]; then
	if [[ "$ctr" == "inc" ]]; then inc="$amt"; fi
	if [[ "$ctr" == "dec" ]]; then dec="$amt"; fi
fi

# Run Operation
if [[ "$ctr" == "inc" ]]; then ibr "$inc"; fi
if [[ "$ctr" == "dec" ]]; then dbr "$dec"; fi

# Clear memory
usv
