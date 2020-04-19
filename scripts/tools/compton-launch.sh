#!/usr/bin/env bash
#
# compton-launch.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Starts & Restarts Compton

# Check for Compton
command -v comtpon >/dev/null || exit 1

# Kill Compton
killall --quiet compton
while pidof compton >/dev/null; do sleep 1; done

# Launch Compton
compton &
