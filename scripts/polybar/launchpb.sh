#!/usr/bin/env bash
#
# launchpb.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Starts & Restarts Polybar

# Check for Polybar
command -v polybar >/dev/null || { notify-send --urgency="critical" --icon="!!!" "Failed to Launch Polybar" 2>/dev/null; exit 1; }

# Kill polybar
killall --quiet polybar
while pidof polybar >/dev/null; do sleep 1; done

# Launch Bar(s)
polybar --config="${HOME}/.config/polybar/config.ini" topbar &
#ln -sf /tmp/polybar_mgqueue.$! /tmp/ipc-topbar
