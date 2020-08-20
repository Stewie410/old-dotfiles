#!/usr/bin/env bash
#
# polybar-start.sh
#
# (re)starts polybar

# Kill polybar
killall --quiet polybar
while pidof polybar >/dev/null; do sleep 1; done

# Launch Bar(s)
polybar --config="${HOME}/.config/polybar/config.ini" topbar &
#ln -sf /tmp/polybar_mgqueue.$! /tmp/ipc-topbar
