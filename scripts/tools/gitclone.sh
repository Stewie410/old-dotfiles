#!/usr/bin/env bash
#
# Wrapper to simplify cloning from common git repository providers

# Show Help/Usage
show_help() {
	cat << EOF
Wrapper to simplify cloning from common git repository providers

USAGE: ${0##*/} [OPTIONS] SLUG

OPTIONS:
	-h, --help		Show this help message
	-g, --github		Assume SLUG is hosted by github
	-l, --gitlab		Assume SLUG is hosted by gitlab
	-s, --suckless		Assume SLUG is hosted by suckless
	-b, --base-url URL	Use URL as base url for SLUG
	-d, --directory PATH	Output contents to PATH instead of './SLUG'

SLUG:
	Slug should follow the format 'owner/repo', for example:

		stewie410/dotfiles
EOF
}

main() {
	local opts url dir
	opts="$(getopt --options hglsd:b: --longoptions help,github,gitlab,suckless,directory:,base-url: --name "${0##*/}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )		show_help; return 0;;
			-g | --github )		url="https://github.com";;
			-l | --gitlab )		url="https://gitlab.com";;
			-s | --suckless )	url="git://git.suckless.org";;
			-b | --base-url )	url="${2}"; shift;;
			-d | --directory )	dir="${2}"; shift;;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	if [ -z "${*}" ]; then
		printf '%s\n' "No slug specified" >&2
		return 1
	fi

	if ! [[ "${*}" = */* ]]; then
		printf '%s\n' "Invalid slug format: '${*}'" >&2
		return 1
	fi

	if [ -z "${url}" ]; then
		printf '%s\n' "No base url specified for slugi: '${*}'" >&2
		return 1
	fi

	git clone "${url}/${*}" "${dir:-${*##*/}}"
}

main "${@}"
