#!/usr/bin/env bash
#
# Display Spotify Now-Playing

spotify-now -i " %artist - %title" -e "closed" -p "paused" | \
    sed 's/^.*ad\(vert\)?//I;s/paused//;s/^/ /' | \
    sed "/^ closed$/d"
