#!/bin/bash
#
# networkchk.sh
# Author:	Alex Paarfus
# Date:		2019-06-22
#
# Check for a network connection ETH and WLP devices
# Now shows Bluetooth Status too!

# Functions
# Get Color
getColor() {
	# Get color Values from Polybar
	up="$(grep "^foreground-alt" "$HOME/.config/polybar/config" | \
		grep -v "vars" | \
		sed 's/^.*{//;s/}//')"
	down="$(grep "^foreground" "$HOME/.config/polybar/config" | \
		grep -v "vars" | \
		sed 's/^.*{//;s/}//')"
	
	# If colorscheme is from Xresources, pull from that directly
	if echo "$up" | grep -q "xres"; then
		up="$(echo "$up" | awk -F[.] '{print $2}')"
		up="$(grep "$up" "$HOME/.Xresources" | grep -v "^!" | \
			awk -F[#] '{print $2}')"
		down="$(echo "$down" | awk -F[.] '{print $2}')"
		down="$(grep "$down" "$HOME/.Xresources" | grep -v "^!" | \
			awk -F[#] '{print $2}')"
	
	# Else, just pull from Polybar
	else
		cs="$(echo "$up" | awk -F[.] '{print $1}')"
		csln="$(grep -n "[$cs]" | sed 1q | awk -F[:] '{print $1}')"

		up="$(echo "$up" | awk -F[.] '{print $2}')"
		up="$(tail -n "+$((csln + 1))" "$HOME/.config/polybar/config" | \
			sed 16q | \
			grep "$up" | \
			sed -r 's/^.*#(.*)}/\1/;y/ABCDEF/abcdef/')"
		down="$(echo "$down" | awk -F[.] '{print $2}')"
		down="$(tail -n "+$csln" "$HOME/.config/polybar/config" | \
			sed 16q | \
			grep "$down" | \
			sed -r 's/^.*#(.*)}/\1/;y/ABCDEF/abcdef/')"
	fi
	
	# Return the correct color
	if [[ "$1" == "up" ]] || [[ "$1" == "UP" ]]; then
		echo "$up"
	else
		echo "$down"
	fi

	# Clear memory
	unset cs csln up down
}

# Vars
wico=""						# Wifi Icon
eico=""						# Ethernet Icon
bico=""						# Bluetooth Icon
nico="X"						# No Network Icon
wstr="$(cat /sys/class/net/w*/operstate)"		# Wifi Status
estr="$(cat /sys/class/net/e*/operstate 2>/dev/null)"	# Ethernet Status
bstr="$(systemctl is-active bluetooth.service)"		# Bluetooth Status
sep=" "							# Seperator String
str=""							# Output String

# Output our Status with correct colors -- TODO: Fix, lol
#echo "%{F#$(getColor "$wstr")}$wico%{F-} %{F#$(getColor "$estr")}$eico%{F-}"

# Handle Arguments -- Currently only a toggle for BT
if [ -n "$1" ]; then
	if [[ "$1" == "bt" ]]; then
		if [[ "$bstr" =~ ^[aA] ]]; then 
			systemctl stop bluetooth
		else
			systemctl start bluetooth
		fi
	fi
fi

# Get our Icon displays for Wifi, Eth and BT
if [[ "$wstr" =~ ^[uU] ]]; then wstr="$wico"; else wstr=""; fi
if [[ "$estr" =~ ^[uU] ]]; then estr="$eico"; else estr=""; fi
if [[ "$bstr" =~ ^[aA] ]]; then bstr="$bico"; else bstr=""; fi

# Build our Output String
if [ -n "$wstr" ]; then str="$wstr"; fi
if [ -n "$estr" ]; then
	if [ -n "$str" ]; then str="$str$estr"; else str="$estr"; fi
fi
if [ -n "$bstr" ]; then
	if [ -n "$str" ]; then str="$str$bstr"; else str="$bstr"; fi
fi
if [ -z "$str" ]; then str="$nico"; fi

if [ -n "$wstr" ]; then str="$wstr"; fi
if [ -n "$estr" ]; then if [ -n "$str" ]; then str="$str$sep"; fi; str="$str$estr"; fi
if [ -n "$bstr" ]; then if [ -n "$str" ]; then str="$str$sep"; fi; str="$str$bstr"; fi
if ! echo "$str" | grep -qE "$wstr|$estr|$bstr"; then str="$nico"; fi

# Return our Status
echo "$str"

# Clear Memory
unset wico eico nico wstr estr str
