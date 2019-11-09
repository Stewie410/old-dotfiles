#!/bin/env bash
#
# bash_functions
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-11-09
#
# A collection of useful functions

# ##------------------------------------##
# #|		Local Functions		|#
# ##------------------------------------##
# Search for a process containing a given name
pps() {
	ps aux | \
		grep "${@}" | \
		grep --invert-match "grep"
}

# pps(), but with regexp
ppse() {
	ps aux | \
		grep --extended-regexp "${@}" | \
		grep --invert-match "grep"
}

# ##------------------------------------##
# #|		cURL Utilities		|#
# ##------------------------------------##
# Cheat.sh -- https://cheat.sh
cheat() { curl --silent --fail "cheat.sh/${@}"; }

# Dictionary
dict() { curl --silent --fail "dict://dict.org/d:${@}"; }

# ##------------------------------------##
# #|		RClone General		|#
# ##------------------------------------##
# Compare repo to local directory -- Args: $1: Repo Name; $2: Local Path
rclcheck() {
	if [ -z "${2}" ]; then
		printf '%s\n' "Usage: rclcheck <repo-name> <local-path>"
		return 1
	fi
	rclone check "${1}:" "${2}"
}

# Synchronize repo item to local item -- Args: $1: Repo Path; $2: Local Path
rclsync() {
	if [ -z "${2}" ]; then
		printf '%s\n' "Usage: rclsync <repo-path> <local-path>"
		return 1
	fi
	rclone sync "${1}" "${2}"
}

# Copy repo path to local path -- Args: $1 Repo path; $2: local path
rclcopy() {
	if [ -z "${2}" ]; then
		printf '%s\n' "Usage: rclcopy <repo-path> <local-path>"
		return 1
	fi
	rclone copy "${1}" "${2}"
}

# ##------------------------------------##
# #|		Git Functions		|#
# ##------------------------------------##
# Git Clone -- Agrs: $1: "GithubUser/GithubRepo"
ghcl() {
	if [ -z "${1}" ]; then
		printf '%s\n' "Usage: ghcl \"<github-user>/<repo-path>\""
		return 1
	fi
	git clone "https://github.com/${@}.git"
}
