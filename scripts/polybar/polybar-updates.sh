#!/usr/bin/env bash
#
# polybar-updates.sh
#
# Get the total number of available packages since last sync

# Print if pacman/yay currently running
( pidof pacman || pidof yay ) >/dev/null && exit

# Print Available Updates
{ checkupdates | awk '{print $1}'; \
    yay --query --upgrades --foreign --aur --quiet; } | \
    sort | \
    uniq | \
    wc --lines | \
	awk '$1 > 0 { print " " $1 }'
{
    checkupdates | awk '{print $1}'
    yay --query --upgrades --foreign --aur --quiet
} | sort | uniq | wc --lines | awk '{print "",$1}'
