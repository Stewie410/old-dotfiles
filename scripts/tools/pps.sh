#!/usr/bin/env bash
#
# Find processes by given PATTERN

# Show Help/Usage
show_help() {
    cat << EOF
Find processes by given PATTERN

USAGE: ${0##*/} [OPTIONS] PATTERN

OPTIONS:
    -h, --help              Show this help message
    -i, --ignore-case       Ignore case distinctions in PATTERN
    -E, --extended-regexp   Interpret PATTERN as an extended regular expression (ERE)
    -F, --fixed-strings     Interpret PATTERN as a list of fixed strings
    -G, --basic-regexp      Interpret PATTERN as a basic regular expression (BRE)
    -P, --perl-regexp       Interpret PATTERN as a Perl-compatible regular expression (PCRE)
EOF
}

# Variables
declare -a grepArgs
trap 'unset grepArgs OPTS' EXIT

# Handle Arguments
OPTS="$(getopt --options hiEFGP --longoptions help,ignore-case,extended-regexp,fixed-strings,basic-regexp,perl-regexp --name "${0##*/}" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help ) 		        show_help; exit 0;;
        -i | --ignore-case )        grepArgs+=("-i");;
        -E | --extended-regexp )    grepArgs+=("-E");;
        -F | --fixed-strings )      grepArgs+=("-F");;
        -G | --basic-regexp )       grepArgs+=("-G");;
        -P | --perl-regexp )        grepArgs+=("-P");;
		-- ) 			            shift; break;;
		* ) 			            break;;
	esac
    shift
done

if [ -z "${*}" ]; then
    printf '%s\n' "ERROR: No pattern specified" >&2
    exit 1
fi

# shellcheck disable=SC2009
ps aux | \
    grep "${grepArgs[@]}" "${*}" | \
    grep --extended-regexp --invert-match "grep|${0##*/}"
exit "${PIPESTATUS[1]}"
