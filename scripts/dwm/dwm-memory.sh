#!/usr/bin/env bash
#
# Display memory usage

free | awk '/^Mem/ {printf "%0.0f%%",$2/$3}' | awk '{print " ",$0""}'
