#!/usr/bin/env bash
#
# Compile a LaTeX document to PDF

show_help() {
	cat << EOF
Compile a LaTeX document to PDF

USAGE: ${0##*/} [OPTIONS] LATEX

OPTIONS:
	-h, --help		Show this help message
EOF
}

main() {
	local opts

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

	if [[ -z "${*}" ]]; then
		printf '%s\n' "No file specified" >&2
		return 1
	fi

	latexmk \
		-f \
		-xelatex \
		-synctex="1" \
		-interaction="nonstopmode" \
		"${1%.*}" >/dev/null
}

main "${@}"
