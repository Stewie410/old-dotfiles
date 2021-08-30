#!/usr/bin/env bash
#
# Report current ram utilization

# Get used RAM percentage
free | awk '/^Mem/ {printf " %0.02f\n", $2/$3}'
