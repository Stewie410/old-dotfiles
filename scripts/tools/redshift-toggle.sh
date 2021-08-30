#!/usr/bin/env bash
#
# Toggles Redshift

# Kill Redshift if running
killall --quiet redshift
while pidof redshift >/dev/null; do sleep 1; done
redshift -l "${1:-geoclue2}" & disown
