#!/usr/bin/env bash
#
# polybar-i3layout.sh
#
# Get i3wm layout icon

i3-msg -t get_tree | \
    jq --raw-output \
        'recurse(.nodes[];.nodes!=null)|select(.nodes[].focused).layout' | \
    sed 's/splitv//I;s/splith//I;s/tab.*//I;s/"//g'
