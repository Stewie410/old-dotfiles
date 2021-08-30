#!/usr/bin/env bash
#
# Synchronize Google Drive if out of date

ping -c 1 8.8.8.8 |& grep --quiet --ignore-case "unreachable" && exit 0
rclone check "GDrive:" "${HOME}/GDrive/" |& grep --quiet " ERROR :" || exit 0
rclone --quiet sync "GDrive:" "${HOME}/GDrive/"
