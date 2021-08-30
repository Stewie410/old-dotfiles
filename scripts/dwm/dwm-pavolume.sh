#!/usr/bin/env bash
#
# Display Volume

# Click Events
case "${BLOCK_BUTTON}" in
    1 )     pamixer --toggle-mute;;
    3 )     setsid --fork "${TERMINAL}" --command pamixer;;
esac

# Get Volume
awk '{print " " $0}' < <(pamixer --get-volume-human)
