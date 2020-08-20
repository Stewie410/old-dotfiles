#!/usr/bin/env bash
#
# polybar-memory.sh
#
# Report current ram utilization

# Get used RAM percentage
free | awk '/^Mem/ {printf " %0.0f\n", $2/$3}'
