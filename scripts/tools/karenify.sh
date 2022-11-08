#!/usr/bin/env bash
#
# Karenify a file

show_help() {
	cat << EOF
Karenify a file

USAGE: ${0##*/} [OPTIONS] FILE

OPTIONS:
    -h, --help      Show this help message
    -i, --invert    Use "AbC" casing
    -a, --awk       Use (g)awk to convert FILE
EOF
}

awk_recase() {
	awk --assign "invert=${invert}" '
		/[a-zA-Z]/ {
			for (i = 1; i < length($0); i++) {
				char = substr($0, i, 1)
				if (char ~ /[a-zA-Z]/) {
					if (last == "") {
						if (invert == 1)
							char = toupper(char)
						else
							char = tolower(char)
					} else if (last ~ /[a-z]/)
						char = toupper(char)
					else
						char = tolower(char)
					last = char
				}
				new = new char
			}
			print new
			new = ""
			next
		}

		{
			print
		}
	' < "${*}"
}

recase() {
	local i line new char last

	while IFS='' read -r line; do
		if ! [[ "${line}" =~ [a-zA-Z] ]]; then
			new="${line}"
		else
			for ((i = 0; i < ${#line}; i++)); do
				char="${line:$i:1}"
				if [[ "${char}" =~ [a-zA-Z] ]]; then
					if [[ -z "${last}" ]]; then
						char="${char,,}"
						[[ -n "${invert}" ]] && char="${char^^}"
					else
						char="${char,,}"
						[[ "${last}" =~ [a-z] ]] && char="${char^^}"
					fi
					last="${char}"
				fi
				new+="${char}"
			done
		fi
		printf '%s\n' "${new}"
		unset new
	done < "${*}"
}

main() {
	local opts invert awk infile

	opts="$(getopt \
		--options hia \
		--longoptions help,invert,awk \
		--name "${0##*/}" \
		-- "${@}" \
	)"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )		show_help; return 0;;
			-i | --invert )		invert="1";;
			-a | --awk )		awk="1";;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	infile="${*:-/dev/stdin}"

	if [[ -n "${awk}" ]]; then
		awk_recase "${infile}" || return
	else
		recase "${infile}" || return
	fi

	return 0
}

main "${@}"
