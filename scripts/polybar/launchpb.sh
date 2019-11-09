#!/bin/env bash
#
# launchpb.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-10-27
#
# Starts & Restarts Polybar

# Check for Polybar
if ! command -v polybar >/dev/null 2>&1; then printf '%s\n' "Cannot locate polybar!"; return 1; fi

# Kill polybar
killall --quiet polybar
while pgrep -x polybar >/dev/null 2>&1; do sleep 1; done

# Launch Bar(s)
polybar topbar &
#ln -sf /tmp/polybar_mgqueue.$! /tmp/ipc-topbar
