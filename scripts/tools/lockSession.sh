#!/bin/env bash
#
# suspend-lock.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-10-27
#
# Lock the session
XDG_SEAT_PATH="/org/freedesktop/DisplayManager/Seat0" dm-tool lock
