#!/usr/bin/env bash
#
# Lock the X session

XDG_SEAT_PATH="/org/freedesktop/DisplayManager/Seat0" dm-tool lock
