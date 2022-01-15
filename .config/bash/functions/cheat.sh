#!/usr/bin/env bash

cheat() {
	local opts
	opts="$(getopt --options h --longoptions help --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Get a cheat-sheet for a command

USAGE: ${FUNCNAME[0]} [OPTIONS] COMMAND

OPTIONS:
	-h, --help		Show this help message
EOF
				return 0
				;;
			-- )			shift; break;;
			* )				break;;
		esac
		shift
	done

	if [ -z "${*}" ]; then
		printf '%s\n' "No command specified" >&2
		return 1
	fi

	curl --silent --fail "cheat.sh/${*}"
}
