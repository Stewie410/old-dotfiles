#!/usr/bin/env bash
#
# Pulls current Artist & Title from Spotify

awk '
    {
        info = " " gensub(/[^Aa]d( - [Aa]dvertisement)?$/, "", 1, $0)
        info = gensub(/paused?/, "", "G", info)
        if (match(info, "closed"))
            info = ""
        printf "%s", info
    }
' < <(spotify-now -i "%artist - %title" -e "closed" -p "paused")
