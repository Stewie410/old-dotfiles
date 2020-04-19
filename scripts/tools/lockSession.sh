#!/usr/bin/env bash
#
# lockSession.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Lock the session
XDG_SEAT_PATH="/org/freedesktop/DisplayManager/Seat0" dm-tool lock
