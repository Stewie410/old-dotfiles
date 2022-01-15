#!/usr/bin/env bash

cld() {
	local opts
	opts="$(getopt --options h --longoptions help --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Compile a LaTeX document to PDF

USAGE: ${FUNCNAME[0]} LATEX

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
		printf '%s\n' "No file specified" >&2
		return 1
	fi

	if ! [ -s "${*}" ]; then
		printf '%s\n' "Input file contains no data" >&2
		return 1
	fi

	if ! command -v latexmk &>/dev/null; then
		printf '%s\n' "Packaging missing or not in PATH: 'latexmk'" >&2
		return 1
	fi

	latexmk -f -xelatex -synctex="1" -interaction="nonstopmode" "${1%.*}" >/dev/null
}
