#!/bin/bash
#
# launchpb.sh
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-01-06
#
# Starts/Restarts Polybar

# Kill Polybar
killall -q polybar

# Wait for polybar to close
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch Bars
polybar topbar &
echo "Polybar Launched"...
