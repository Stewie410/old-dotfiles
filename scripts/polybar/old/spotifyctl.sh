#!/bin/bash
#
# spotifyctl.sh
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-02-02
# 
# Pulls current Artist & Title from Spotify
# Requres:
#	spotify
#	spotify-now

# Functions
# Search for spotify binary in $PATH
isInstalled() {
	instSpot="0"		# Installation status of Spotify
	instSNow="0"		# Installation status of Spotify-Now

	# Iterate over path, looking for spotify and spotify-now
	if find "/usr/bin" -maxdepth 1 -name "spotify" ! -name "spotify-now" -type f >/dev/null; then instSpot="1"; fi
	if find "/usr/bin" -maxdepth 1 -name "spotify-now" -type f >/dev/null; then instSNow="1"; fi

	# Return whether or not spotify & spotify-now is installed
	if [ "$instSpot" -eq 1 ] && [ "$instSNow" -eq 1 ]; then echo "1"; else echo "0"; fi

	# Clear memory
	unset instSpot instSNow
}

# Vars
ico=""						# Bar Icon
str=""						# Status

if [ "$(isInstalled)" -eq 1 ]; then
	# Get our status if spotify is installed && running
	if pgrep -x "spotify" >/dev/null; then
		str="$(spotify-now -i "%artist - %title" 2>/dev/null)"
		# Format our String
		# Shorten to 30 characters
		if [ "${#str}" -gt 30 ]; then str="${str:0:30}..."; fi
		
		# If its an ad playing, change to "#Ad"
		if [[ "$str" =~ ^[aA]d(vertisement)? ]]; then str="#AD"; fi

		# Update output string with icon
		str="$ico $str"
	fi
fi

echo "$str"

# Clear memory
unset ico str
