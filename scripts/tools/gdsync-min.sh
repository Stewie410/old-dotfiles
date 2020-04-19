#!/usr/bin/env bash
#
# gdsync-min.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-11
#
# Synchronize Google Drive if out of date, with minimal lines

ping -c 1 8.8.8.8 |& grep --quiet --ignore-case "unreachable" && exit
rclone check "GDrive:" "${HOME}/GDrive/" |& grep --quiet " ERROR :" || exit
rclone --quiet sync "GDrive:" "${HOME}/GDrive/"
