#!/usr/bin/env bash
#
# Mount Devices with dmenu as a front-end

notifyMount() {
    notify-send "Mounded: '${dev##*/}' -> '${point:-N/A}'"
}

notifyFail() {
    notify-send --urgency="critical" "Failed to mount: '${dev##*/}' -> '${point:-N/A}'"
}

getDevice() {
    lsblk --list | awk '
        /part\s*$/ {
            print $1 " (" $4 ")"
        }
    ' | dmenu -p "Select Device: "
}

getFstabEntry() {
    local uuid
    uuid="$(sudo blkid | awk --assign "dev=${dev}" 'match($0, dev) { print gensub(/^.*="(.*)"$/, "\\1", 1, $2)}')"

    awk --assign "dev=${dev}" --assign "uuid=${uuid:-N/A}" '
        match($1, dev "|UUID=" uuid) {
            print $2
        }
    ' "/etc/fstab"
}

getPoint() {
    local fstab
    fstab="$(getFstabEntry)"
    if [ -n "${fstab}" ]; then
        printf '%s\n' "${fstab}"
        return
    fi

    find /mnt /media /mount "${HOME}" -maxdepth 1 -type d | \
        dmenu -p "Select Mount Point: "
}

mkpoint() {
    [ -d "${point}" ] && return

    local confirmation
    confirmation="$(printf '%s\n' "Yes" "No" | dmenu -p "Create mount point: '${point}'? ")"
    [[ "${confirmation,,}" != "yes" ]] && return 1
    mkdir --parents "${point}" 2>/dev/null && return
    sudo mkdir --parents "${point}"
}

mountDev() {
    mount "/dev/${dev}" "${point}" 2>/dev/null && return
    sudo mount "/dev/${dev}" "${point}"
}

# Variables
declare dev point
trap 'unset dev point' EXIT

# Dmenu cannot currently be running
pidof dmenu >/dev/null && exit 0

# Something must be available to mount
lsblk --list | grep --extended-regexp --quiet 'part\s*$' || exit 0

# Get device & mount point
dev="$(getDevice)"
point="$(getPoint)"

# Create mount point, if necessary
if ! mkpoint; then
    notifyFail
    exit 10
fi

# Mount device
if ! mountDev; then
    notifyFail
    exit 11
fi
notifyMount
