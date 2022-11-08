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
    -f, --forest            Show processes with ASCII art process heirarchy
EOF
}

main() {
	local -a args
	local opts nocase forest
	opts="$(getopt \
		--options hif \
		--longoptions help,ignore-case,forest \
		--name "${0##*/}" \
		-- "${@}" \
	)"

	args=("a" "u" "x")

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )				show_help; return 0;;
			-i | --ignore-case )		nocase="1";;
			-f | --forest )				forest="1";;
			-- )						shift; break;;
			* )							break;;
		esac
		shift
	done

	[[ -n "${forest}" ]] && args+=("f")

	ps "${args[@]}" | awk --assign "filter=${*:-.*}" --assign "nocase=${nocase:-0}" '
		BEGIN {
			IGNORECASE = nocase
		}

		NR == 1 {
			print
		}

		match($0, filter) && !match($0, "ps aux") {
			print
		}
	'
}

main "${@}"
