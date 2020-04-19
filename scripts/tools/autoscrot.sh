#!/usr/bin/env bash
#
# autoscrot.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Take screenshot with scrot

# Declare Variables
declare dst count
trap "unset dst count" EXIT

# Return if required commands not found
command -v scrot >/dev/null || exit 1

# Define Variables
dst="${HOME}/Pictures/Screenshots"
find "${dst}" -mindepth 1 -maxdepth 1 -type f -name "*capture_*" | \
    wc --lines | \
    read -r count

# Take Screenshot
scrot "${dst}/capture_${count}.png"
