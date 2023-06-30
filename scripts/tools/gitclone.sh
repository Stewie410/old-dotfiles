#!/usr/bin/env bash
#
# Wrapper to simplify cloning from common git repository providers

# Show Help/Usage
show_help() {
	cat << EOF
Wrapper to simplify cloning from common git repository providers

USAGE: ${0##*/} [OPTIONS] SLUG [OUTDIR]

OPTIONS:
    -h, --help              Show this help message
    -g, --github            Pull from github (default)
    -l, --gitlab            Pull from gitlab
    -s, --suckless          Pull from suckless
    -b, --base-url URL      Pull from URL

SLUG:
	Slug should follow the format 'owner/repo'
EOF
}

main() {
	local -A bases
	local opts url

	opts="$(getopt \
		--options hglsb: \
		--longoptions help,github,gitlab,suckless,base-url: \
		--name "${0##*/}" \
		-- "${@}" \
	)"

	bases['hub']="https://github.com"
	bases['lab']="https://gitlab.com"
	bases['suc']="https://git.suckless.org"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )		show_help; return 0;;
			-g | --github )		url="${bases['hub']}";;
			-l | --gitlab )		url="${bases['lab']}";;
			-s | --suckless )	url="${bases['suc']}";;
			-b | --base-url )	url="${2}"; shift;;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	if [[ -z "${1}" ]]; then
		printf '%s\n' "No SLUG specified" >&2
		show_help
		return 1
	elif [[ "${1}" != */* ]]; then
		printf '%s\n' "Invalid SLUG format" >&2
		show_help
		return 1
	fi

	git clone "${url:-${bases['hub']}}/${1}.git" "${outdir:-${PWD}/${1##*/}}"
}

main "${@}"
