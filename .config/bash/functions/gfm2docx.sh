#!/usr/bin/env bash

gfm2docx() {
	local opts reference
	reference="${WINHOME}/OneDrive - WT Cox/.config/gfm2docx/reference.docx"
	opts="$(getopt --options hr: --longoptions help,reference: --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Convert Github Flavored Markdown (GFM) to DOCX

USAGE: ${FUNCNAME[0]} [OPTIONS] GFM [DOCX]

OPTIONS:
	-h, --help		Show this help message
	-r, --reference	PATH	Specify the reference file path

DOCX:
	If not specified, use path/filename of GFM
EOF
				return 0
				;;
			-r | --reference )	reference="${2}"; shift;;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	if [ -z "${*}" ]; then
		printf '%s\n' "No GFM file specified" >&2
		return 1
	fi

	if ! [ -s "${1}" ]; then
		printf '%s\n' "GFM contains no data" >&2
		return 1
	fi

	if ! [ -s "${reference}" ]; then
		printf '%s\n' "Cannot locate reference file: '${reference}'" >&2
		return 1
	fi

	if ! command -v pandoc &>/dev/null; then
		printf '%s\n' "Package missing or not in PATH: 'pandoc'" >&2
		return 1
	fi

	pandoc --from="gfm" --to="docx" --reference-doc="${reference}" --out="${2:-${1%.*}.docx}" "${1}"
}
