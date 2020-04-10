#!/bin/env bash
#
# spotifyctl.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-10
#
# Pulls current Artist & Title from Spotify
# Requires:
#	spotify
#	spotify-now

# Check for requirements
command -v spotify >/dev/null || exit 1
command -v spotify-now >/dev/null || exit 1

# Return if Spotify isn't running
pidof -s spotify >/dev/null || { printf "\n"; exit; }

# Get Status
spotify-now -i "%artist - %title" | sed 's/^.*ad\(vert\)\?.*/#Ad/'
