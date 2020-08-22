#!/usr/bin/env bash
#
# Display Volume

# Click Events
case "${BLOCK_BUTTON}" in
    1 )     pamixer --toggle-mute;;
    3 )     sedsid --fork "${TERMINAL}" --command pamixer;;
esac

# Get Volume
pamixer --get-volume-human | awk '{print " ",$0}'
