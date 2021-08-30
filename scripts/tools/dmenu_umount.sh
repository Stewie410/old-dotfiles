#!/usr/bin/env bash
#
# Unmount Devices with dmenu as a frontend

notifyUmount() {
    notify-send "Unmounted: '${dev##*/}'"
}

notifyFailed() {
    notify-send --urgency="critical" "Failed to unmount: '${dev##*/}'"
}

getDevice() {
    lsblk --list | awk '
        $0 ~ /part\s*[^\s]+$/ && $NF !~ /(boot|SWAP)/ {
            print $1 " (" $4 ")"
        }
    ' | dmenu -p "Select Device: "
}

unmountDevice() {
    umount "${dev}" 2>/dev/null && return
    sudo umount "${dev}"
}

# Variables
declare dev
trap 'unset dev' EXIT

# Abort if dmenu already running
pidof dmenu >/dev/null && exit 0

# Get device to unmount
dev="$(getDevice)"
[ -n "${dev}" ] || exit 10
if ! [ -b "${dev}" ]; then
    notifyFailed
    exit 11
fi

# Unmount device
if ! unmountDevice; then
    notifyFailed
    exit 12
fi
notifyUmount
