#!/usr/bin/env bash
#
# hwstats.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Reports various hardware stats

# Declare Variables
declare str
trap "unset str" EXIT

# CPU Temperature
if command -v sensors >/dev/null; then
    str+=" "
    str+="$(sensors --no-adapter | \
        awk '/^Core/ {cnt += 1; sum += $3} END {printf "%0.0f\n", sum/cnt}')"
    str+="°C | "
fi

# CPU Frequency
if command -v cpupower >/dev/null; then
    str+=" "
    str+="$(cpupower frequency-info --freq --human | \
        awk '/current/ {print $4$5}')"
    str+=" | "
fi

# RAM Utilization
str+=" $(free | \
    awk '/^Mem/ {printf "%0.0f\n", $2/$3}')% | "

# Disk Utilization
#str+=" $(df --human-readable --local |& \
#    sed '/^[^\/]/d;/boot/d' | \
#    awk '{printf "%s %s ", $NF, $(NF-1)} END {print ""}') | "

# Display Status
printf '%b\n' "${str::-3}"
