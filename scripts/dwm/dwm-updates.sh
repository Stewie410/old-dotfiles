#!/usr/bin/env bash
#
# Get total number of available updates

getAUR() {
    aura -Au --dryrun | awk '
        BEGIN { cnt = 0 }
        /->/ && !seen[$1]++ { cnt += 1 }
        END { printf "%s", cnt }
    '
}

getSTD() {
    aura -Qu | awk '
        BEGIN { cnt = 0 }
        !seen[$1]++ { cnt += 1 }
        END { printf "%s", cnt }
    '
}

# Do not get new values if pacman or AUR helpers are running
pidof pacman aura &>/dev/null && exit

# Print both standard & AUR updates available
printf ' %s | %s' "$(getSTD)" "$(getAUR)"
