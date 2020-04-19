#!/usr/bin/env bash
#
# ramutil.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
#
# Report current ram utilization

# Get used RAM percentage
free | \
    awk '/^Mem/ {printf "%0.0f\n", $2/$3}' | \
    xargs -I {} printf '%s\n' " {}%"
