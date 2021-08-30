#!/usr/bin/env bash
#
# Reports the average CPU Frequency

# Get frequency
command -v "cpupower" >/dev/null || exit
awk '/current/ {print "", $4 $5}' < <(cpupower frequency-info --freq --human)
