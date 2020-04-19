#!/usr/bin/env bash
#
# cputemp.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
#
# Reports the average CPU Core temperature

# Get temperature
command -v sensors >/dev/null || return
sensors --no-adapter | \
    awk '/^Core/ {cnt += 1; sum += $3} END {printf "%0.0f\n", sum/cnt}' | \
    xargs -I {} printf '%s\n' " {}°C"
