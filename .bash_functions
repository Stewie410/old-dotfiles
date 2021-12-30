#!/bin/env bash

# Find Processes :: String keyword
pps() {
	if command -v pgrep &>/dev/null; then
		prgep "${*}"
	else
		ps aux | grep "${*}" | sed '/^grep/d'
	fi
}

# Get a cheat-sheet :: String keyword
cheat() { curl --silent --fail "cheat.sh/${*}"; }

# Get a dictionary definition(s) :: String keyword
dict() { curl --silent --fail "dict://dict.org/d:${*}"; }

# Make and change to a directory :: String path
mkcd() {
	local date opts working
	working="${WORKING_DIR:-${HOME}/working}"
	opts="$(getopt --options htyld: --longoptions help,today,yesterday,linux,date: --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Make and change directory

USAGE: ${FUNCNAME[0]} [OPTIONS] [PATH]

OPTIONS:
	-h, --help		  Show this help message
	-t, --today		 Today's working directory
	-y, --yesterday	 Yesterday's working directory
	-l, --linux		 Use the linux working path ('\${HOME}/working') instead of Windows ('\${WORKING_DIR}')
	-d, --date DATE	 DATE's working directory

PATH:
	PATH is ignored for working-directory options

DATE:
	DATE should follow 'date -d' formatting
EOF
				return 0
				;;
			-t | --today )	  date="today";;
			-y | --yesterday )  date="yesterday";;
			-l | --linux )	  working="${HOME}/working";;
			-d | --date )	   date="${2}"; shift;;
			-- )				shift; break;;
			* )				 break;;
		esac
		shift
	done

	if [ -n "${date}" ]; then
		if ! date --date="${date}" &>/dev/null; then
			printf '%s\n' "Invalid date format: '${date}'" >&2
			return 1
		fi
		working+="/$(date --date="${date}" --iso-8601)"
		if ! mkdir --parents "${working}" &>/dev/null; then
			printf '%s\n' "Failed to create working directory: '${working}'" &>2
			return 1
		fi
		if ! cd "${working}" &>/dev/null; then
			printf '%s\n' "Failed to navigate to working directory: '${working}'" >&2
			return 1
		fi
	else
		if ! mkdir --parents "${*}" &>/dev/null; then
			printf '%s\n' "Failed to create directory: '${*}'" >&2
			return 1
		fi
		if ! cd "${*}" &>/dev/null; then
			printf '%s\n' "Failed to navigate to directory: '${*}'" >&2
			return 1
		fi
	fi

	return 0
}

# Working-Directory creation
mdot() { mkcd --today "${@}"; }
mdoy() { mkcd --yesterday "${@}"; }
mdod() { mkcd --date "${@}"; }

# Convert GFM to DOCX :: String Markdown, [String docx]
gfm2docx() {
	pandoc \
		--from="gfm" \
		--to="docx" \
		--referece-doc="${OneDrive:-${WINHOME:-${HOME}}}/.config/gfm2docx/reference.docx" \
		--out="${2:-${1%.*}.docx}" \
		"${*}"
}

# Compile LaTeX document
cld() { latexmk -f -xelatex -synctex=1 -interaction=nonstopmode "${1%.*}" >/dev/null; }

# Karenify a string
karenify() {
	local opts invert i
	opts="$(getopt --options hi --longoptions help,invert --name "${FUNCNAME[0]}" -- "${@}")"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
Karenify a string

USAGE: ${FUNCNAME[0]} [OPTIONS] STRING

OPTIONS:
	-h, --help		Show this help message
	-i, --invert	Use "AbC" casing format (default: "aBc")
EOF
				return 0
				;;
			-i | --invert )		invert="1";;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	[ -n "${*}" ] || return

	mapfile -t chars <<< "$(grep --only-matching . <<< "${*}")"

	if [ -n "${invert}" ]; then
		chars[0]="${chars[0]^^}"
	else
		chars[0]="${chars[0],,}"
	fi

	for ((i = 1; i < ${#chars[@]}; i++)); do
		if [[ "${chars[${i}]}" =~ [a-zA-Z] ]]; then
			if [[ "${chars[$((i - 1))]}" =~ [A-Z] ]]; then
				chars[${i}]="${chars[${i}],,}"
			else
				chars[${i}]="${chars[${i}]^^}"
			fi
		fi
	done

	printf '%s\n' "${chars[@]}" | paste --serial --delimiter='\0'
}

# File/Path Bookmarks...and maybe some other stuff
bm() {
	local opts add delete list config update edit path
	opts="$(getopt --options hea:dlc:u: --longoptions help,edit,add:,delete,list,config:,update: --name "${FUNCNAME[0]}" -- "${@}")"
	config="${XDG_CONFIG_HOME:-${HOME}/.config}/bookmarks/bm.rc"

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )
				cat << EOF
File/Path Bookmarks...and maybe some other stuff eventually

USAGE: ${FUNCNAME[0]} [OPTIONS] BOOKMARK

OPTIONS:
	-h, --help				Show this help message
	-e, --edit				Open the configuration file in \$EDITOR (vi as a fallback)
	-a, --add PATH			Add a new BOOKMARK pointing to PATH
	-u, --update PATH		Update BOOKMARK's path to PATH
	-d, --delete			Remove BOOKMARK from configuration
	-l, --list				List current bookmarks, filter by BOOKMARK if specified
	-c, --config PATH		Use PATH as config, rather than '~/.config/bookmarks/config'

CONFIG
	If either the specified configuratoin file, or the default, does nto exist
	it **will** be created at execution.

	The configuration file should be formatted as
		BOOKMARK = PATH
EOF
				return 0
				;;
			-d | --delete )			delete="1";;
			-l | --list )			list="1";;
			-e | --edit )			edit="1";;
			-a | --add )			add="1"; path="${2}"; shift;;
			-u | --update )			update="1"; path="${2}"; shift;;
			-c | --config )			config="${2}"; shift;;
			-- )					shift; break;;
			* )						break;;
		esac
		shift
	done

	[[ "${config%/*}" != "${config}" ]] && mkdir --parents "${config%/*}"
	touch -a "${config}"

	if [ -n "${list}" ]; then
		awk --assign "filter=${*:-.*}" 'match($0, filter)' "${config}" || return
	elif [ -n "${edit}" ]; then
		"${EDITOR:-$(command -v vi)}" "${config}" || return
	elif [ -z "${*}" ]; then
		printf '%s\n' "No bookmark specified" >&2
		return 1
	fi

	if [ -n "${add}" ] || [ -n "${update}" ]; then
		path="$(realpath "${path/~/${HOME}}")"
		if grep --quiet "${*} = " "${config}"; then
			if [ -n "${add}" ]; then
				printf '%s\n' "Bookmark already defined" >&2
				return 1
			fi
			sed -i'' "s|^${*} = .*$|${*} = ${path}|" "${config}" || return
		else
			if [ -n "${update}" ]; then
				printf '%s\n' "Bookmark is not defined" >&2
				return 1
			fi
			printf '%s = %s\n' "${*}" "${path}" >> "${config}" || return
		fi
	elif [ -n "${delete}" ]; then
		if ! grep --quiet "^${*} = " "${config}"; then
			printf '%s\n' "Bookmark is not defined" >&2
			return 1
		fi
		sed -i'' "/^${*} = .*$/d" "${config}" || return
	elif ! cd "$(grep "^${*} = " "${config}" | cut --fields="3-" --delimiter=" ")"; then
		printf '%s\n' "Failed to navigate to bookmark" >&2
		return 1
	fi

	return 0
}
