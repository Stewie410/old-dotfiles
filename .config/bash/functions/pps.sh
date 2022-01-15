#!/usr/bin/env bash
# shellcheck disable=SC2009

pps() {
	local opts regex
	opts="$(getopt --options hE --longoptions help,extended-regexp --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Find Processes

USAGE: ${FUNCNAME[0]} [OPTIONS] PATTERN

OPTIONS:
	-h, --help		Show this help message
	-E, --extended-regexp	Interpret PATTERN as extended regular expression
EOF
				return 0
				;;
			-E | --extended-regexp )	regex="1";;
			-- )						shift; break;;
			* )							break;;
		esac
		shift
	done

	if [ -z "${*}" ]; then
		printf '%s\n' "No pattern specified" >&2
		return 1
	fi

	if [ -n "${regex}" ]; then
		ps aux | grep --extended-regexp "${*}" | grep --invert-match "grep"
		return
	fi

	ps aux | grep "${*}" | grep --invert-match "grep"
}
