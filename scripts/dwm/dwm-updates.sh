#!/usr/bin/env bash
#
# Get total number of available updates

# Abort if package manager(s) running
( pidof pacman || pidof yay ) >/dev/null && exit

{
    checkupdates | awk '{print $1}'
    yay --query --upgrades --foreign --aur --quiet
} | sort | uniq | wc --lines | awk '{print "",$0}'
