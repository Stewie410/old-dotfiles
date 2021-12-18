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
	-h, --help		Show this help message
EOF
}

main() {
	local log opts
	log="/var/log/$(basename "${0##*/}")/$(date --iso-8601).log"

	opts="$(getopt --options h --longoptions help --name "${0##*/}" -- "${@}")"
	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )		show_help; return 0;;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	mkdir --parents "${log%/*}"
	touch -a "${log}"
}

main "${@}"
