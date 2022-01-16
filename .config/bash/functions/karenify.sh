#!/usr/bin/env bash

karenify() {
	local opts invert newline i
	opts="$(getopt --options hin --longoptions help,invert,newline --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Karenify a string
USAGE: ${FUNCNAME[0]} [OPTIONS] [STRING]
OPTIONS:
	-h, --help		Show this help message
	-i, --invert	Use "AbC" casing format (default: "aBc")
	-n, --newline	Append a newline to the end of the result
STRING:
	If not text is supplied on the command line, read text from stdin
EOF
				;;
			-i | --invert )		invert="1";;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	set -- "${*:-$(</dev/stdin)}"
	mapfile -t chars <<< "$(grep --only-matching . <<< "${*}")"

	chars[0]="${chars[0],,}"
	[ -n "${invert}" ] && chars[0]="${chars[0]^^}"

	for ((i = 1; i < ${#chars[@]}; i++)); do
		if [[ "${chars[${i}]}" =~ [a-zA-Z] ]]; then
			chars[${i}]="${chars[${i}]^^}"
			[[ "${chars[$((i - 1))]}" =~ [A-Z] ]] && chars[${i}]="${chars[${i}],,}"
		fi
	done

	printf '%s' "${chars[@]}"
	[ -n "${newline}" ] && printf "\n"
	return 0
}
