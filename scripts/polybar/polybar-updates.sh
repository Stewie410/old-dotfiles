#!/usr/bin/env bash
#
# Get the total number of available packages since last sync

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

# Print if pacman/yay currently running
( pidof pacman || pidof paru ) >/dev/null && exit

# Print Available Updates
printf ' %s | %s' "$(checkupdates | getCount)" "$(paru -Qu | getCount)"
