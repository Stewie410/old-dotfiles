#!/usr/bin/env bash
#
# updateschk.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Get the total number of available packages since last sync
# Requires:
#	-yay
# 	-checkupdates

# Exit on error
ping -c 1 "8.8.8.8" |& grep --quiet --ignore-case "unreachable" && exit 1
command -v checkupdates >/dev/null || exit 1
command -v yay >/dev/null || exit 1

# Print if pacman/yay currently running
( pidof pacman || pidof yay ) >/dev/null && exit

# Print Available Updates
{ checkupdates | awk '{print $1}'; \
    yay --query --upgrades --foreign --aur --quiet; } | \
    sort | \
    uniq | \
    wc --lines | \
	awk '$1 > 0 { print " " $1 }'
