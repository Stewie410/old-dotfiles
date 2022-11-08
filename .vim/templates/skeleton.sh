#!/usr/bin/env bash
#
# Description

log() {
	printf '[%s] [%s] %s\n' "$(date --iso-8601=sec)" "${FUNCNAME[1]}" "${*}" | tee --append "${log:-/dev/null}"
}

show_help() {
	cat << EOF
Description

USAGE: ${0##*/} [OPTIONS]

OPTIONS:
    -h, --help      Show this help message
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
