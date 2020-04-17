#!/usr/bin/env bash
#
# networkchk.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
#
# Retrieve network/radio status & control bluetooth

# Show Help
show_help() {
    cat << EOF
Retrieve network/radio status & control bluetooth

USAGE: networkchk.sh [options]

Options:
    -h, --help          Show this help message
    -b, --bluetooth     Toggle bluetooth status, if available
EOF
}

# Declare Variables
declare string
trap "unset string" EXIT

# Handle Arguments
if command -v getopt >/dev/null; then
    OPTS="$(getopt --options hb --long-options help,bluetooth --name "networkchk.sh" -- "${@}")"
    eval set -- "${OPTS}"
    while true; do
        case "${1}" in
            -b | --bluetooth )
                [ ! -s "/usr/lib/systemd/system/bluetooth.service" ] && exit 1
                systemctl is-active --quiet bluetooth && { systemctl stop bluetooth; exit; }
                systemctl start bluetooth
                exit
                ;;
            * ) show_help; exit;;
        esac
    done
fi

# Get Status
for i in $(ip route |& awk '/^[0-9]/ {print $3}'); do
    [[ "${i,,}" =~ ^w ]] && { string+=" "; continue; }
    [[ "${i,,}" =~ ^e ]] && { string+=" "; continue; }
    [[ "${i,,}" =~ ^t ]] && { string+=" "; continue; }
done
[ -s "/usr/lib/systemd/system/bluetooth.service" ] && { systemctl --quiet is-active bluetooth && string+=" "; }

# Print Status
printf '%s\n' "${string:-1}"
