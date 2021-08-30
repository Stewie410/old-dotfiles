#!/usr/bin/env bash
#
# Display Spotify Now-Playing

awk '
    {
        info = " " gensub(/^[Aa]d( - [Aa]dvertisement)?$/, "", 1, $0)
        info = gensub(/paused/, "", 1, info)
        if (match(info, "closed"))
            info = ""
        printf "%s", info
    }
' < <(spotify-now -i "%artist - %title" -e "closed" -p "paused")
