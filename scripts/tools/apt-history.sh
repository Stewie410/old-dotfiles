#!/usr/bin/env bash

main() {
	local log
	log="/var/log/dpkg.log"

	case "${1,,}" in
		install )					sed --quiet '/install /p' "${log}";;
		upgrade | remove )			sed --quiet "/${1,,}/p" "${log}";;
		rollback )
			sed --quiet '/upgrade/p' "${log}" | \
				grep "${2}" --after-context="10000000" | \
				grep "${3}" --before-context="10000000" | \
				awk '{print $4, "=", $4}'
			;;
		-h | --help | h | help )	printf 'USAGE: %s {install|upgrade|remove|rollback}\n' "${FUNCNAME[0]}";;
		* )							cat "${log}";;
	esac
}

main "${@}"
