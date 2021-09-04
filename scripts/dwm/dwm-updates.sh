#!/usr/bin/env bash
#
# Get total number of available updates

getAUR() {
    aura -Au --dryrun | awk '
        /->/ && !seen[$1]++ {
            cnt += 1
        }

        END {
            printf "%s", cnt
        }
    '
}

getSTD() {
    aura -Qu | awk '
        !seen[$1]++ {
            cnt += 1
        }

        END {
            printf "%s", cnt
        }
    '
}

# Do not get new values if pacman or AUR helpers are running
for i in "pacman" "yay" "paru" "aura"; do
    pidof "${i}" &>/dev/null && exit
done

# Print both standard & AUR updates available
printf ' %s | %s' "$(getSTD)" "$(getAUR)"
