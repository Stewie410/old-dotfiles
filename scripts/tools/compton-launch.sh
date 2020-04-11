#!/bin/env bash
#
# compton-launch.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-11
# 
# Starts & Restarts Compton

# Check for Compton
command -v compton >/dev/null || { printf '%s\n' "Cannot locate compton"; exit 1; }

# Kill Compton
killall --quiet compton
while pgrep -x compton >/dev/null; do sleep 1; done

# Launch Compton
compton &
