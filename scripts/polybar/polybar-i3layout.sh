#!/usr/bin/env bash
#
# Get i3wm layout icon

i3-msg -t get_tree | \
    jq --raw-output 'recurse(.nodes[];.nodes!=null)|select(.nodes[].focused).layout' | \
    awk '
        BEGIN { IGNORECASE = 1 }
        /splitv/ { layout = "" }
        /splith/ { layout = "" }
        /tab.*/  { layout = "" }
        END { print layout }
    '
