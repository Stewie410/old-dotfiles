#!/usr/bin/env bash
#
# Retrieve network/radio status & control bluetooth

usage() {
    cat << EOF
Display network/radio status & control bluetooth

USAGE:  ${0##*\/} [-h|--help][-b|--bluetooth]

Options:
    -h, --help          Show this help message
    -b, --bluetooth     Toggle Bluetooth radio
EOF
}

getIcons() {
    awk '
        /scope/ {
            if (match($0, "dev w"))
                print ""
            else if (match($0, "dev e"))
                print ""
            else if (match($0, "dev t"))
                print ""
        }
    ' < <(ip route)
    systemctl --quiet is-active bluetooth && printf '%s\n' ""
}

toggleBluetooth() {
    local action
    action="start"
    systemctl --quiet is-active bluetooth && action="stop"
    systemctl "${action}" bluetooth
}

# Handle arguments
if [[ "${*,,}" =~ -(h|-help) ]]; then
    show_help
elif [[ "${*,,}" =~ -(b|-bluetooth) ]]; then
    toggleBluetooth
else
    getIcons | paste --serial --delimiter=" " | tr --delete '\n'
fi
