#!/usr/bin/env bash
#
# redshift-toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Toggles Redshift
# Usage:	redshift-toggle.sh [location]

# Check requiered packages
command -v redshift >/dev/null || exit 1

# Kill Redshift if running
killall --quiet redshift
while pidof redshift >/dev/null; do sleep 1; done

# Start Redshift
redshift -l "${1:-geoclue2}" & disown
