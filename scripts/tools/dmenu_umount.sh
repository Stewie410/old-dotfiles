#!/usr/bin/env bash
#
# dmenu_umount.sh
#
# Unmount Devices with dmenu as a frontend

# Always unset variables
trap "unset dev" EXIT

# Display notification
umounted() { notify-send "Unmounted '${dev##*\/}'"; }
noumount() { notify-send --urgency="critical" "Failed to unmount '${dev}'"; }

# Abort if dmenu is already running
pidof dmenu >/dev/null && exit

# Get device to unmount
dev="$(lsblk --list | awk '/part [^ ]+$/ {print $1,"("$4")"}' | \
    sed '/boot/d' | dmenu -p "Unmount Device")"
[ -n "${dev}" ] || exit 1
dev="/dev/${dev% *}"
[ -s "${dev}" ] || { noumount; exit 1; }

# Unmount Device
sudo umount "${dev}" || { noumount; exit 1; }
umounted
