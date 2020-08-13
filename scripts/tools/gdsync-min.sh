#!/usr/bin/env bash
#
# gdsync-min.sh
#
# Synchronize Google Drive if out of date, with minimal lines

ping -c 1 8.8.8.8 |& grep --quiet --ignore-case "unreachable" && \
    { printf '%s\n' "No Network Connection"; exit 1; }
rclone check "GDrive:" "${HOME}/GDrive/" |& grep --quiet " ERROR :" && \
    rclone --quiet sync "GDrive:" "${HOME}/GDrive/"
