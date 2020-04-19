#!/usr/bin/env bash
#
# spotifyctl.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Pulls current Artist & Title from Spotify

# Check for requirements
command -v spotify >/dev/null || exit 1
command -v spotify-now >/dev/null || exit 1

# Get status
spotify-now -i "%artist - %title" -e "closed" | \
    sed 's/^.*ad\(vert\)\?//;s/^closed$//I'
