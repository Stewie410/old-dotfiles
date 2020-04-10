#!/bin/env bash
#
# hwstats.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-10
#
# Reports Current:
#	-Average CPU Temperature
#	-CPU Frequency
#	-RAM Utilization
# Requires:
#	-lm_sensors
#	-cpupower

# Return if commands missing
command -v sensors >/dev/null || exit 1
command -v cpupower >/dev/null || exit 1

# Get Stats
{ sensors --no-adapter; cpupower frequency-info --freq --human; free; } | \
	sed --quiet '/^Core\|Mem/p;/current/p' | \
	awk '/^Core/ { CORE += 1; SUM += $3} /current/ {FREQ = $4$5} /^Mem/ {MEM = $2/$3}
		END {printf "%s %0.0f%s | %s | %0.0f%%\n", "", SUM/CORE, "°C", FREQ, MEM}'
