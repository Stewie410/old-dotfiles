#!/usr/bin/env bash

pem2crt() {
	local opts
	opts="$(getopt --options h --longoptions help -- "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Convert a PEM certificate to CRT

USAGE: ${FUNCNAME[0]} [OPTIONS] PEM [CRT]

OPTIONS:
	-h, --help		Show this help message

CRT:
	If not CRT is specified, use path/filename of PEM
EOF
				return 0
				;;
			-- )			shift; break;;
			* )				break;;
		esac
		shift
	done

	if [ -z "${*}" ]; then
		printf '%s\n' "No PEM specified" >&2
		return 1
	fi

	if ! [ -s "${1}" ]; then
		printf '%s\n' "PEM contains no data" >&2
		return 1
	fi

	if ! command -v openssl &>/dev/null; then
		printf '%s\n' "Missing package, or not in path: 'openssl'" >&2
		return 1
	fi

	openssl x509 -outform der -in "${1}" -out "${2:-${1%.*}.crt}"
}
