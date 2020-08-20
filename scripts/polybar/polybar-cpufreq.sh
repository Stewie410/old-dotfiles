#!/usr/bin/env bash
#
# polybar-cpufreq.sh
#
# Reports the average CPU Frequency

# Get frequency
cpupower frequency-info --freq --human | \
    awk '
        /current/ {
            print """,$4$5
        }
    '
