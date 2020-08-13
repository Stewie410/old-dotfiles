#!/usr/bin/env bash
#
# autoscrot.sh
#
# Take screenshot with scrot

# Get filename
out="${HOME}/Pictures/Screenshots"
read -r count <<< \
    "$(find "${out}" -mindepth 1 -maxdepth 1 -type f -name "*capture_*.png" | \
        wc --lines)"
trap "unset out count" EXIT

# Take Screenshot
scrot "${out}/capture_${count}.png"
