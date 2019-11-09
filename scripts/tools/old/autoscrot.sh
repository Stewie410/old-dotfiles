#!/bin/bash
#
# autoscrot.sh
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-01-11
#
# Takes a screenshot with scrot and generates a simple name for the file

# Vars
odir="$HOME/Pictures/Screenshots"	# Output Directory
bfn="capture_"				# Base Filename
cnt=0					# Number of Filename
ext="png"				# Extension

# Prerun checks
# Output dir exists
if [ ! -d  "$odir" ]; then mkdir -p "$odir"; fi

# Grab $cnt
for (( i=0; i>=0; i++ )); do
	if [ ! -f "$odir/$bfn$i.$ext" ]; then cnt="$i"; break; fi
done

# Scrot
scrot "$odir/$bfn$cnt.$ext"

# Cleanup memory
unset odir bfn cnt ext i
