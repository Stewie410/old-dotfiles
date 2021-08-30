#!/usr/bin/env bash
#
# Description

# Print message to terminal & logfile :: String type, String message
printMsg() {
    [ -n "${2}" ] || return
    printf '[%s] [%s] %s\n' "$(date --iso-8601=sec)" "${1^^}" "${2}" | \
        tee --append "${log}"
}


# Show Help/Usage
show_help() {
    cat << EOF
Description

USAGE: ${0##*/} [OPTIONS]

OPTIONS:
    -h, --help      Show this help message
EOF
}

# Variables
log="/var/log/$(basename "${0##*/}")/$(date --iso-8601).log"
trap 'unset log OPTS' EXIT

# Handle Arguments
OPTS="$(getopt --options h --longoptions help --name "${0##*/}" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help ) 		show_help; exit 0;;
		-- ) 			    shift; break;;
		* ) 			    break;;
	esac
    shift
done

# Generate Logfile
mkdir --parents "${log%/*}"
[ -s "${log}" ] && printf '\n\n%80s\n'  " " | tr ' ' "-" >> "${log}"
touch -a "${log}"

# Run
