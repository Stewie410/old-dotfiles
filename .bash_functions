#!/usr/bin/env bash

bm() {
	local -A defaults settings
	local opts i
	opts="$(getopt \
		--options hea:dlc:u: \
		--longoptions help,edit,add:,delete,list,config:,update: \
		--name "${FUNCNAME[0]}" \
		-- "${@}" \
	)"

	defaults[config]="${XDG_CONFIG_HOME:-${HOME}/.config}/bookmarks/bm.rc"
	defaults[action]="cd"

	for i in "${!defaults[@]}"; do settings["${i}"]="${defaults[${i}]}"; done

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
CD, but with bookmarks/aliases

USAGE: ${FUNCNAME[0]} [OPTIONS] BOOKMARK

OPTIONS:
    -h, --help          Show this help message
    -e, --edit          Edit the configuration file (\$EDITOR or vi)
    -a, --add PATH      Add PATH as BOOKMARK
    -u, --update PATH   Set BOOKMARK as PATH
    -d, --delete        Remove BOOKMARK from configuration
    -l, --list          List existing bookmarks, filter by BOOKMARK if specified (regex)
    -c, --config PATH   Use PATH as config (default: '${defaults[config]}')
EOF
				return 0
				;;
			-a | --add )		settings[action]="add"; path="${2}"; shift;;
			-d | --delete )		settings[action]="remove";;
			-l | --list )		settings[action]="list";;
			-c | --config )		settings[config]="${2}"; shift;;
			-u | --update )		settings[action]="update"; path="${2}"; shift;;
			-e | --edit )		settings[action]="edit";;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	[[ "${config%/*}" != "${config}" ]] && mkdir --parents "${config%/*}"
	touch -a "${config}"

	if [[ "${settings[action]}" == "cd" && -z "${settings[path]}" ]]; then
		printf '%s\n' "No action or bookmark specified" >&2
		return 1
	fi
	[[ -n "${path}" ]] && path="$(realpath "${path/~/${HOME}}")"

	case "${settings[action]}" in
		add )
			if grep --quiet "^${*} = " "${settings[config]}"; then
				printf '%s\n' "Bookmark is already defined" >&2
				return 2
			fi
			printf '%s = %s\n' "${*}" "${settings[path]}" >> "${settings[config]}"
			;;
		remove )
			if ! grep --quiet "^${*} = " "${settings[config]}"; then
				printf '%s\n' "Bookmark is not defined" >&2
				return 2
			fi
			sed -i'' "/^${*} = /d" "${settings[config]}"
			;;
		list )
			awk --assign "filter=${*:-.*}" 'match($0, filter)' "${settings[config]}"
			;;
		update )
			if ! grep --quiet "^${*} = " "${settings[config]}"; then
				printf '%s\n' "Bookmark is not defined" >&2
				return 2
			fi
			sed -i'' "s/^${*} = .*/${*} = ${settings[path]}" "${settings[config]}"
			;;
		edit )
			"${EDITOR:-$(command -v vi)}" "${settings[config]}"
			;;
		cd )
			cd "$(awk --assign "bm=${*}" '
				$1 == bm {
					print gensub(/^[^=]*?] /, "", 1, $0)
				}
			')" || return 3
			;;
		* )
			printf '%s\n' "Unimplemented function: '${settings[action]}'" >&2
			return 99
			;;
	esac

	return 0
}

mkcd() {
	local -A defaults settings
	local opts i
	opts="$(getopt \
		--options hd:w: \
		--longoptions help,date:,working: \
		--name "${FUNCNAME[0]}" \
		-- "${@}" \
	)"

	defaults[working]="${WORKING_DIR:-${HOME}/working}"
	defaults[date]=""

	for i in "${!defaults[@]}"; do settings["${i}"]="${defaults[${i}]}"; done

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Make and change directory

USAGE: ${FUNCNAME[0]} [OPTIONS] PATH

OPTIONS:
    -h, --help          Show this help message
    -d, --date DATE     Make and change to DATE's working directory
    -w, --working PATH  Use PATH as working directory (default: '${defaults[working]}')
EOF
				return 0
				;;
			-d | --date )		settings[date]="${2}"; shift;;
			-w | --working )	settings[working]="${2}"; shift;;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	if [[ -n "${settings[date]}" ]]; then
		working+="/$(date --date="${settings[date]}" --iso-8601 2>/dev/null)"
		if [[ "${settings[working]}" == "${defaults[working]}/" ]]; then
			printf '%s\n' "Invalid date format: '${settings[date]}'" >&2
			return 1
		fi
		set -- "${settings[working]}"
	fi

	mkdir --parents "${*}"
	cd "${*}" || return
}

mdot() { mkcd --date "today"; }
mdoy() { mkcd --date "yesterday"; }
mdod() { mkcd --date "${*}"; }
