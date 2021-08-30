#!/usr/bin/env bash
#
# Display memory usage

awk '/^Mem/ {printf " %0.0f%%",$2/$3}' < <(free)
