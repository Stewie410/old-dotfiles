#!/usr/bin/env bash
#
# Reports the average CPU Core temperature

awk '
    /^Core/ {
        cnt += 1
        sum += $3
    }
    END {
        printf " %0.0f°C", sum/cnt
    }
' < <(sensors --no-adapter)
