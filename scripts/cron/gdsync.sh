#!/bin/env bash
#
# gdsync.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-06-22
#
# Synchronize Google Drive if out of date

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Clear Memory
usv() { unset _loc _rem; }

# Check if offline
isOffline() { ping -c 1 "8.8.8.8" 2>&1 | grep --quiet --ignore-case "unreachable"; }

# Get number of differences
getDiff() {
	rclone check "${_rem}:" "${_loc}/" 2>&1 | \
		sed --quiet '/Failed/p' | \
		cut --fields=6 --delimiter=' '
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
_loc="${HOME}/GDrive"										# Path to local repo
_rem="GDrive"											# "Path" to remove repo

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check for online status
if isOffline; then exit 1; fi

# Check if repo is already synchronized
if [[ "$(getDiff)" == 0 ]]; then exit; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Synchronize
rclone --quiet sync "${_rem}:" "${_loc}/"
