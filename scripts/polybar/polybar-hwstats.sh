#!/usr/bin/env bash
#
# polybar-hwstats.sh
#
# Reports:
#   average cpu-core temperature
#   cpu frequency
#   memory utilization
#   disk utilization

{
    sensors --no-adapter
    cpupower frequency-info --freq --human
    free
    df --human-readable --local | sed '/^[^\/]/d;/boot/d'
} | awk '
        /^Core/ {
            cnt += 1
            sum += $3
        }
        /current/ {
            freq = $4$5
        }
        /^Mem/ {
            mem = $2/$3
        }
        /^\/dev\// {
            disks = disks " " $NF ":" $(NF-1)
        }
        END {
            printf " %0.0f°C  %s %0.0f%% %s\n",sum/cnt,freq,mem,disks
        }
    '
