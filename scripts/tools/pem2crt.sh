#!/usr/bin/env bash
#
# Convert a PEM certificate to CRT

show_help() {
	cat << EOF
Convert a PEM certificate to CRT

USAGE: ${0##*/} [OPTIONS] PEM [CRT]

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
	elif ! [[ -s "${*}" ]]; then
		printf '%s\n' "File does not exist or is empty" >&2
		return 2
	fi

	openssl x509 -outform der -in "${1}" -out "${2:-${1%.*}.crt}"
}

main "${@}"
