#!/usr/bin/env bash
#
# Workaround to adjust the gamma of eDP1 in lieu of xbacklight working as expected

# Show Help
show_help() {
    cat << EOF
Get or set xrandr gamma level to simulate brightness

NOTE: This is a workaround to adjust gamma when xbacklight isn't supported

USAGE: ${0##*/} [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -i, --increase NUM  Increase the gamma percentage by NUM
    -d, --decrease NUM  Decreate the gamma percentage by NUM
    -s, --set NUM       Set the gamma percentage to NUM
    -r, --reset         Reset the gamma percentage to 50%
EOF
}

getGammaLevel() {
    xrandr --current --verbose --screen 0 | awk '
        /Brightness/ {
            printf "%0.0f", $NF * 100
        }
    '
}


getNewLevel() {
    awk --assign "change=${*}" '
        {
            print ($0 + (change)) / 100
        }
    ' < <(getGammaLevel)
}

setGammaLevel() {
    xrandr --screen 0 --brightness "${*}"
}

# Handle Arguments
OPTS="$(getopt --options hri:d:s: --longoptions help,reset,increase:,decrease:,set: --name "${0##*/}" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help )		show_help; exit;;
        -r | --reset )      setGammaLevel "0.5"; exit;;
        -i | --increase )   num="$(getNewLevel "${2}")"; shift;;
        -d | --decrease )   num="$(getNewLevel "${2}")"; shift;;
        -s | --set )        num="$(awk '{print $0 / 100}' <<< "${2}")"; shift;;
		-- )			    shift; break;;
		* )			        break;;
	esac
    shift
done

# Set a new gamma level
if [ -n "${num}" ]; then
    setGammaLevel "${num}"
    exit
fi

# Get current gamma level
getGammaLevel
