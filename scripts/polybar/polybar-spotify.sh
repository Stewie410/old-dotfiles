#!/usr/bin/env bash
#
# polybar-spotify.sh
#
# Pulls current Artist & Title from Spotify

spotify-now -i "%artist - %title" -e "closed" -p "paused" | \
    sed 's/^.*ad\(vert\)\?//;s/paused//;s/^/ /' | \
    sed 's/^ closed$/d'
