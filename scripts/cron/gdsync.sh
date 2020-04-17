#!/bin/env bash
#
# gdsync.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
#
# Synchronize Google Drive if out of date

# Variables
loc="${HOME}/GDrive"
rem="GDrive"
trap "unset loc rem" EXIT

# Perform sync if online && local is out of date
ping -c 1 8.8.8.8 |& grep --quiet --ignore-case "unreachable" && exit
rclone check "${rem}:" "${loc}/" |& grep --quiet " ERROR :" || exit

# Sync Changes
rclone --quiet sync "${rem}:" "${loc}/"
