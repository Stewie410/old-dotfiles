#!/bin/env bash
#
# gdsync.sh
#
# Synchronize Google Drive if out of date

ping -c 8.8.8.8 |& grep --quiet --ignore-case "unreachable" && \
    { printf '%s\n' "No Network Connection"; exit 1; }
rclone check "GDrive:" "${HOME}/GDrive/" |& grep --quiet " ERROR :" && \
    rclone --quiet sync "GDrive:" "${HOME}/GDrive/"
