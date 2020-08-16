#!/usr/bin/env bash
#
# dmenu_mount.sh
#
# Mount Devices with dmenu as a front-end

# Always unset variables
trap "unset dev point ans" EXIT

# Display notification
mounted() { notify-send "Mounted '${dev##*\/}' -> ${point:-N/A}"; }
nomount() { notify-send --urgency="critical" "Failed to mount '${dev}' -> '${point:-N/A}'"; }

# Abort if dmenu is already running
pidof dmenu >/dev/null && exit

# Abort if no devices to mount
lsblk --list | grep --quiet "part *$" || exit

# Select Device
dev="$(lsblk --list | awk '/part *$/ {print $1,"("$4")"}' | dmenu -p "Mount Device")"
[ -n "${dev}" ] || exit 1
dev="/dev/${dev% *}"

# Mount according to fstab, if exists
uuid="$(sudo blkid | grep "${dev}" | cut --fields=2 --delimiter=" " | sed 's/^.*=//;s/"//g"')"
if grep --quiet "${dev}" "/etc/fstab"; then
    point="$(grep "${dev}" "/etc/fstab" | awk '{print $2}')"
    sudo mount "${dev}" || { nomount; exit 1; }
    mounted
    exit
elif grep --quiet "${uuid}" "/etc/fstab"; then
    point="$(grep "${uuid}" "/etc/fstab" | awk '{print $2}')"
    sudo mount "${uuid}" || { nomount; exit 1; }
    mounted
    exit
fi

# Get Mountpoint
point="$(find /mnt /media /mount "${HOME}" -maxdepth 1 -type d | dmenu -p "Mount Point")"
[ -n "${dev}" ] || exit 1

# Create Mountpoint
if ! [ -d "${point}" ]; then
    ans="$(printf '%s\n' "Yes" "No" | dmenu -p "Create '${point}'")"
    [[ "${ans,,}" =~ ^y ]] || { nomount; exit 1; }
    mkdir --parents "${point}" || sudo mkdir --parents "${point}" || { nomount; exit 1; }
fi

# Mount Device
sudo mount "${dev}" "${point}" || { nomount; exit 1; }
mounted
