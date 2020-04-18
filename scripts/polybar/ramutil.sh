#!/usr/bin/env bash
#
# ramutil.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
#
# Report current ram utilization

# Get used RAM percentage
printf '%s\n' " $(free | awk '/^Mem/ {printf "%0.0f", $2/$3}')%"
