#!/bin/env bash
#
# compton-launch.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-10-26
# 
# Starts & Restarts Compton

# Check for Compton
if ! command -v compton >/dev/null 2>&1; then printf '%s\n' "Cannot locate polybar!"; return 1; fi

# Kill Compton
killall --quiet compton
while pgrep -x compton >/dev/null 2>&1; do sleep 1; done

# Launch Compton
compton &
