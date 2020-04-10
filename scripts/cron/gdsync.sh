#!/bin/env bash
#
# gdsync.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-10
#
# Synchronize Google Drive if out of date

# Clear Memory
trap "unset loc rem" EXIT

# Return if offline
ping -c 1 "8.8.8.8" |& grep --quiet --ignore "unreachable" && exit

# Define remote & local repositories
loc="${HOME}/GDrive"
rem="GDrive"

# Return if no changes
rclone check "${rem}:" "${loc}/" |& grep --quiet " ERROR :" || exit

# Sync Changes
rclone --quiet sync "${rem}:" "${loc}/"
