#!/usr/bin/env bash

mkcd() {
	local date opts parent
	working="${WORKING_DIR:-${HOME}/working}"
	opts="$(getopt --options htyld: --longoptions help,today,yesterday,linux,date: --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Make and change directory

USAGE: ${FUNCNAME[0]} [OPTIONS] [PATH]

OPTIONS:
	-h, --help		Show this help message
	-t, --today		Today's working directory
	-y, --yesterday		Yesterday's working directory
	-d, --date DATE		DATE's working directory
	-l, --linux		Assume working parent directory is ~/working
EOF
				return 0
				;;
			-t | --today )		date="today";;
			-y | --yesterday )	date="yesterday";;
			-d | --date )		date="${2}"; shift;;
			-l | --linux )		working="${HOME}/working";;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	if [ -n "${date}" ]; then
		working+="/$(date --date="${date}" --iso-8601 2>/dev/null)"
		if [[ "${working}" == "${WORKING_DIR:-${HOME}/working}/" ]]; then
			printf '%s\n' "Invalid date format: '${date}'" >&2
			return 1
		fi
		mkdir --parents "${working}" || return
		cd "${working}" || return
	else
		mkdir --parents "${*}" || return
		cd "${*}" || return
	fi

	return 0
}
