#!/bin/env bash
#
# autoscrot.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-10
#
# Takes a screenshot with scrot & stores it in the specified location
# Requires:
# 	-scrot

# Clear Memory
trap "unset dst count" EXIT

# Return if required commands not found
command -v scrot >/dev/null || exit 1

# Define Variables
dst="${HOME}/Pictures/Screenshots"
count="$(find "${dst}" -mindepth 1 -maxdepth 1 -type f -name "*capture_*" | wc --lines)"

# Take Screenshot
scrot "${dst}/capture_${count}.png"
