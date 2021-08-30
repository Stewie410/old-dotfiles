#!/usr/bin/env bash
#
# Toggle the TapToClick functionality of the touchpad

getDeviceID() {
    xinput --list --short | awk '
        /Touchpad/ {
            print substr($6, 4)
        }
    '
}

getProperty() {
    xinput --list-props "${device}" | awk '
        /Tapping Enabled \(/ {
            print substr($4, 2, 3)
        }
    '
}

getState() {
    xinput --list-props "${device}" | awk --assign "id=${property}" '
        match($4, id) {
            print $NF
        }
    '
}

# Variables
declare device property state
trap 'unset device property state' EXIT

# Require xinput
if ! command -v "xinput" >/dev/null; then
    printf '%s\n' "FATAL: Cannot find required application: 'xinput'"
    exit 10
fi

# Require X Session
if ! xinput >/dev/null 2>&1; then
    printf '%s\n' "FATAL: Cannot connect to X server"
    exit 11
fi

# Get device
device="$(getDevice)"
if [ -z "${device}" ]; then
    printf '%s\n' "FATAL: Cannot locate touchpad"
    exit 12
fi

# Get property
property="$(getProperty)"
if [ -z "${property}" ]; then
    printf '%s\n' "FATAL: Cannot locate property: 'Tapping Enabled'"
    exit 13
fi

# Get Current State
state="$(getState)"
if [ -z "${state}" ]; then
    printf '%s\n' "FATAL: Cannot determine property state: '${property}'"
    exit 14
fi

# Toggle State
xinput --set-prop "${device}" "${property}" "$((1 - state))"
