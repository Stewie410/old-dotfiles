#!/usr/bin/env bash
#
# ttc_toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Toggle the TapToClick functionality of the touchpad

# Declare variables
declare dev prop state
trap "unset dev prop state" EXIT

# Device ID
read -r dev <<< "$(xinput --list --short | awk '/Touchpad/ {print substr($6,4)}')"

# Prop ID & State
read -r prop state <<< "$(xinput --list-props | \
    awk '/Tapping Enabled \(/ {print substr($4,2,3),$NF}')"

# Toggle State
xinput --set-prop "${dev}" "${prop}" "$((1-state))"
