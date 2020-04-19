#!/usr/bin/env bash
#
# ttc_toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Toggle the TapToClick functionality of the touchpad

# Declare variables
declare dev prop state
trap "unset dev prop state" EXIT

# Check for required commands
command -v xinput >/dev/null || exit 1

# Get device ID
xinput --list --short | \
    grep "Touchpad" | \
    sed '/^.*=//' | \
    cut --fields=1 | \
    read -r dev || exit 1

# Get Property ID
xinput --list-props "${dev}" | \
    sed --quiet '/tapping enabled (/Ip' | \
    sed 's/^.*(//;s/).*$//' | \
    read -r prop

# Get State
xinput --list-props "${dev}" | \
    grep "${prop}" | \
    awk '{print $NF}' | \
    read -r state
if ((state)); then state="0"; else state="1"; fi

# Toggle State
xinput --set-prop "${dev}" "${prop}" "${state}"
