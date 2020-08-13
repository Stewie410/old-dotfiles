#!/usr/bin/env bash
#
# compton-launch.sh
#
# Starts & Restarts Compton

killall --quiet compton
while pidof compton >/dev/null; do sleep 1; done
compton &
