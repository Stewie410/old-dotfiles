#!/usr/bin/env bash
#
# Get total number of available updates

getCount() {
    awk '
        {
            seen[$1]++
            if (seen[$1] == 1)
                count += 1
        }

        END {
            printf "%s", count
        }
    '
}

# Abort if package manager(s) running
( pidof pacman || pidof yay ) >/dev/null && exit

printf ' %s | %s' "$(checkupdates | getCount)" "$(paru -Qu | getCount)"
