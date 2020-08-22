#!/usr/bin/env bash
#
# Display the Date-Time stamp

# Click Events
case "${BLOCK_BUTTON}" in
    1 ) notify-send "$(date)" && notify-send "$(calcurse --date 3)";;
    3 ) setsid --force "${TERMINAL}" --command calcurse;;
esac

date +'%I:%M %p'
