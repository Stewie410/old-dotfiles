#!/usr/bin/env bash

dict() {
	local opts
	opts="$(getopt --options h --longoptions help --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Get a dictionary definition

USAGE: ${FUNCNAME[0]} [OPTIONS] WORD

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
		printf '%s\n' "No word specified" >&2
		return 1
	fi

	curl --silent --fail "dict://dict.org/d:${*}"
}
