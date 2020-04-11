#!/bin/env bash
#
# redshift-toggle.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-11
#
# Toggles Redshift
# Usage:	redshift-toggle.sh [location]

# Check requiered packages
command -v redshift >/dev/null || { printf '%s\n' "Cannot find Redshift!"; exit 1; }

# Kill Redshift if running
pgrep --exact "redshift" && { killall --quiet "redshift"; exit; }

# Start Redshift
[ -n "${1}" ] && { redshift -l "${1}" & disown; exit; }
redshift -l "geoclue2" & disown
