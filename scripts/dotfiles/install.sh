#!/usr/bin/env bash
#
# Install/Setup WSL2 dotfiles (bare) a bit easier

cleanup() {
	unset log
}

log() {
	printf '%s|%s|%s\n' "$(date --iso-8601=sec)" "${FUNCNAME[1]}" "${1}" | \
		tee --append "${log:-/dev/null}" | \
		cut --fields="2-" --delimiter=" "
}

show_help() {
	cat << EOF
Install/Setup WSL2 dotfiles (bare) a bit easier

USAGE: ${0##*/} [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -g, --git-dir PATH      Path to store git repo files (default: '${defaults['git_dir']}')
    -w, --work-tree PATH    Path of the git repo's working-tree (default: '${defaults['work_tree']}')
    -b, --backup PATH       Path to store existing config files (default: '${defaults['backup']}')
    -B, --branch BRANCH     Branch to checkout (default: '${defaults['branch']}')
EOF
}

clone() {
	git clone --bare 'https://githubusercontent.com/Stewie410/dotfiles.git' "${settings['git_dir']}"
}

bare() {
	git --git-dir="${settings['git_dir']}" --work-tree="${settings['work_tree']}" "${@}"
}

checkout() {
	if ! bare branch | grep --quiet "${1}"; then
		log "Branch does not exist: '${1}" >&2
		return 1
	fi

	if ! bare checkout "${1}"; then
		while read -r item; do
			log "Archiving config: '${item}' -> '${2}/${item}'"
			[[ "${item%/*}" != "${item}" ]] && mkdir --parents "${2}/${item}"
			mv "${item}" "${2}/${item}"
		done < <(bare checkout "${1}" |& awk '/^\s+/ { print gensub(/^\s+/, "", 1, $0) }')

		bare checkout "${1}"
	fi

	gdf config "status.showUntrackedFiles" "no"
	return 0
}

main() {
	local -A defaults settings
	local opts i
	opts="$(getopt \
		--options hg:w:b:B: \
		--longoptions help,git-dir:,work-tree:,backup:,branch: \
		--name "${0##*/}" \
		-- "${@}" \
	)"

	defaults['git_dir']="${HOME}/.dotfiles_repo"
	defaults['work_tree']="${HOME}"
	defaults['backup']="${XDG_DATA_HOME:-$HOME/.local/share}/old_dotfiles"
	defaults['branch']="wsl2"

	for i in "${!defaults[@]}"; do settings["$i"]="${defaults["$i"]}"; done

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )		show_help; return 0;;
			-g | --git-dir )	settings['git_dir']="${2}"; shift;;
			-w | --work-tree )	settings['work_tree']="${2}"; shift;;
			-b | --backup )		settings['backup']="${2}"; shift;;
			-B | --branch )		settings['branch']="${2}"; shift;;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	if ! command -v git &>/dev/null; then
		printf '%s\n' "Please install required package: 'git'" >&2
		return 1
	fi

	mkdir --parents "${log%/*}"
	touch -a "${log}"

	if ! [[ -d "${settings['git_dir']}" ]]; then
		if ! clone; then
			log "Failed to clone repository!" >&2
			return 1
		fi
	fi

	checkout "${settings['branch']}" "${settings['backup']}"
}

log="${HOME}/.local/logs/scripts/dotfiles/$(basename "${0%.*}").log"
trap cleanup EXIT

# shellcheck disable=SC1090
main "${@}" && source "${HOME}/.bashrc"
