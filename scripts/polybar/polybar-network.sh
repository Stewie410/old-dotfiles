#!/usr/bin/env bash
#
# polybar-network.sh
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

# Handle arguments
trap "unset OPTS" EXIT
OPTS="$(getopt --options hb --longoptions help,bluetooth --name "${0##*\/}" -- "${@}")"
eval set -- "${OPTS}"
while true; do
    case "${1}" in
        -h | --help )       usage; exit;;
        -b | --bluetooth )
            if systemctl is-active --quiet bluetooth; then
                systemctl stop bluetooth
            else
                systemctl start bluetooth
            fi
            shift
            ;;
        -- )                shift; break;;
        * )                 break;;
    esac
done

# Get Status
{
    ip route | \
        tr '[:upper:]' '[:lower:]' | \
        grep --ignore-case "scope" | \
        awk '/dev w/{print ""}/dev e/{print ""}/dev t/{print ""}'
    systemctl --quiet is-active bluetooth && echo ""
} | paste --serial --delimiter=" "
