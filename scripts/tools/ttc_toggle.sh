#!/bin/env bash
#
# ttc_toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-11
#
# Toggle the TapToClick functionality of the touchpad
# Requires:
#	-xinput

# Clear memory on Exit
trap "unset dev prop state" EXIT

# Check for required commands
command -v xinput >/dev/null || { printf '%s\n' "Failed to locate xinput"; exit 1; }

# Define Variables
dev="12"
prop="278"

# Get DeviceID
[ -n "${dev}" ] || \
	dev="$(xinput --list --short | awk 'BEGIN {IGNORECASE = 1} /touchpad/ {print $6}' | cut --fields=2 --delimiter="=")"

# Get Property
[ -n "${prop}" ] || \
	prop="$(xinput --list-props "${dev}" | awk 'BEGIN {IGNORECASE = 1} /tapping enabled \(/ {print $4}' | sed 's/[^0-9]//g')"

# Get State
state="$(xinput --list-props "${dev}" | sed --quiet "/${prop}/p" | awk '{print $NF}')"
if ((state)); then state="0"; else state="1"; fi

# Toggle State
xinput --set-prop "${dev}" "${prop}" "${state}"
