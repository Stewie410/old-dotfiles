#!/usr/bin/env bash
#
# Synchronize Google Drive if out of date, with minimal lines

if ping -c 1 8.8.8.8 |& grep --quiet --ignore-case "unreachable"; then
    printf '%s\n' "No network connection" >&2
    exit 1
fi

remote="GDrive:"
clone="${HOME}/GDrive/"
trap 'unset remote clone' EXIT

! rclone check "${remote}" "${clone}" |& grep --quiet " ERROR :" || exit 0
rclone sync "${remote}" "${clone}"
