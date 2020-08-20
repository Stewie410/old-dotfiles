#!/usr/bin/env bash
#
# polybar-cputemp.sh
#
# Reports the average CPU Core temperature

sensors --no-adapter | \
    awk '
        /^Core/ {
            cnt += 1
            sum += $3
        }
        END {
            printf "🌡 %0.0f°C", sum/cnt
        }
    '
