#!/usr/bin/env bash
#
# Wrapper to simplify cloning from common git repository providers

# Show Help/Usage
show_help() {
    cat << EOF
Wrapper to simplify cloning from common git repository providers

USAGE: ${0##*/} [OPTIONS] SLUG [DIRECTORY]

OPTIONS:
    -h, --help      Show this help message
    -g, --github    Assume SLUG is hosted by github
    -l, --gitlab    Assume SLUG is hosted by gitlab
    -s, --suckless  Assume SLUG is hosted by suckless

SLUG:
    Slug should follow the format 'owner/repo', for example:

        stewie410/dotfiles
EOF
}

# Variables
declare url
trap 'unset url' EXIT

# Handle Arguments
OPTS="$(getopt --options hgls --longoptions help,github,gitlab,suckless --name "${0##*/}" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help ) 		show_help; exit 0;;
        -g | --github )     url="https://github.com";;
        -l | --gitlab )     url="https://gitlab.com";;
        -s | --suckless )   url="git://git.suckless.org";;
		-- ) 			    shift; break;;
		* ) 			    break;;
	esac
    shift
done

# Require SLUG
if [ -z "${1}" ]; then
    printf '%s\n' "ERROR: No SLUG specified" >&2
    exit 1
fi

# Require SLUG host
if [ -z "${url}" ]; then
    printf '%s\n' "ERROR: No host specified" >&2
    exit 1
fi

# Clone
git clone "${url}/${1}" "${2:-${1##*/}}"
