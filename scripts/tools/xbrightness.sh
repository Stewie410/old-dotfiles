#!/usr/bin/env bash
#
# Get or modify the brightness level

show_help() {
	cat << EOF
Get or modify the brightness level

USAGE: ${0##*/} [OPTIONS]

Options:
    -h, --help              Show this help message
    -i, --increase NUM      Increase the brightness percentage by NUM
    -d, --decrease NUM      Decrease the brightness percetnage by NUM
    -s, --set NUM           Set brightness percentage to NUM
EOF
}

getBrightnessLevel() {
    brightnessctl info | awk '
        /Current/ { current = $3 }
        /Max/ { max = $3 }
        END {
            printf "%0.0f", (current / max) * 100
        }
    '
}

notify() {
    command -v notify-send >/dev/null || return
    notify-send --urgency="low" "${*}"
}

# Variables
declare num
trap 'unset num OPTS' EXIT

# Handle Arguments
OPTS="$(getopt --options hi:d:s: --longoptions help,increase:,decrease:,set: --name "${0##*/}" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help ) 		show_help; exit 0;;
        -i | --increase )   num="+${2}%"; shift;;
        -d | --decrease )   num="${2}%-"; shift;;
        -s | --set )        num="${2}%"; shift;;
		-- ) 			shift; break;;
		* ) 			break;;
	esac
done

# Require brightnessctl
if ! command -v "brightnessctl" >/dev/null; then
    printf '%s\n' "FATAL: Cannot find required application: 'brightnessctl'"
    exit 10
fi

# Modify brightness
if [ -n "${num}" ]; then
    if ! brightnessctl --quiet set "${num}"; then
        notify "Failed to modify brightness: '${0##*/}'"
        exit 1
    fi
    notify "Brightness: '$(getBrightnessLevel)%'"
fi

# Get current brightness
getBrightnessLevel
