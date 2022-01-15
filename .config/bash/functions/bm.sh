#!/usr/bin/env bash

bm() {
	local opts action config path
	action="none"
	opts="$(getopt --options hea:dlc:u: --longoptions help,edit,add:,delete,list,config:,update: --name "${FUNCNAME[0]}" -- "${@}")"
	config="${XDG_CONFIG_HOME:-${HOME}/.config}/bookmarks/bm.rc"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
CD, but with bookmarks/aliases

USAGE: ${FUNCNAME[0]} [OPTIONS] BOOKMARK

OPTIONS:
	-h, --help		Show this help message
	-e, --edit		Edit configuration file (\$EDITOR or vi)
	-a, --add PATH		Add 'BOOKMARM = PATH' to config
	-u, --update PATH	Update BOOKMARK's path to PATH
	-d, --delete		Remove BOOKMARK from config
	-l, --list		List existing bookmarks, filter by BOOKMARK if specified
	-c, --config PATH	Use PATH as config, rather than default (~/.config/cd_bookmarks/config)

CONFIG
	If either the specified configuration file, or the default, does not exist,
	it **will** be created at execution.

	The configuration file should be formatted as
		BOOKMARK = PATH
EOF
				return 0
				;;
			-a | --add )		action="add"; path="${2}"; shift;;
			-d | --delete )		action="delete";;
			-l | --list )		action="list";;
			-c | --config )		config="${2}"; shift;;
			-u | --update )		action="update"; path="${2}"; shift;;
			-e | --edit )		action="edit";;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	[[ "${config%/*}" != "${config}" ]] && mkdir --parents "${config%/*}"
	touch -a "${config}"

	if [ -z "${action}" ] && [ -z "${*}" ]; then
		printf '%s\n' "No action or bookmark specified" >&2
		return 1
	fi

	[ -n "${path}" ] && path="$(realpath "${path/~/${HOME}}")"
	case "${action}" in
		add )
			if grep --quiet "^${*} = " "${config}"; then
				printf '%s\n' "Bookmark is already defined" >&2
				return 1
			fi
			printf '%s\n' "${*} = ${path}" >> "${config}"
			;;
		delete )
			if ! grep --quiet "^${*} = " "${config}"; then
				printf '%s\n' "Bookmark is not defined" >&2
				return 1
			fi
			sed -i'' "/^${*} = /d" "${config}"
			;;
		list )
			awk --assign "filter=${*:-.*}" 'match($0, filter)' "${config}"
			;;
		update )
			if ! grep --quiet "^${*} = " "${config}"; then
				printf '%s\n' "Bookmark is not defined" >&2
				return 1
			fi
			sed -i'' "s/^${*} = .*\$/${*} = ${path}" "${config}"
			;;
		edit )
			"${EDITOR:-$(command -v vi)}" "${config}"
			;;
		* )
			if [ -z "${*}" ]; then
				printf '%s\n' "No bookmark specified" >&2
				return 1
			fi
			cd "$(grep "^${*} = " "${config}" | cut --fields="3-" --delimiter=" ")" || return 1
			;;
	esac

	return 0
}
