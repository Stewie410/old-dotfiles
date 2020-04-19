#!/usr/bin/env bash
#
# i3layout.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
#
# Get i3wm layout icon

# Get Icon for Layout Type
i3-msg -t get_tree | \
    jq --raw-output \
        'recurse(.nodes[];.nodes!=null)|select(.nodes[].focused).layout' | \
    sed 's/splitv//I;s/splith//I;s/tab.*//I;s/"//g'
