#!/bin/env bash
#
# bash_functions
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-11-09
#
# A collection of useful functions

# ##--------------------------------------------##
# #|		Process Management		|#
# ##--------------------------------------------##
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
# #|		Device Mounting		|#
# ##------------------------------------##
mountdev() {
	if pgrep -x dmenu >/dev/null; then return; fi						# Break if dmenu is currently running
	local _dev_avail _dev_select _point_avail _point_select mdc				# Declare local variables

	# Get current available devices and mount points
	_dev_avail="$(lsblk --list --paths | awk '/part $/ {print $1, "(" $4 ")"}')"		# Get available devices
	_point_avail="$(find /mnt /media /mount /home -type d -maxdepth 3 2>/dev/null)"		# Get available mountpoints
	
	# Get device selection from user
	_dev_select="$(echo "${_dev_avail}" | dmenu-xres.sh -i -p "Mount which drive?" | awk '{print $1}')"	# Get selected device
	if [ -z "${_dev_select}" ]; then return; fi						# Break if nothing chosen

	# Get Mount Point
	if grep --quiet "${_dev_select}" "/etc/fstab"; then					# If device is defined in fstab
		sudo mount "${_dev_select}"							# Mount Device
		return										# Break
	fi
	_point_select="$(echo "${_point_avail}" | dmenu-xres.sh -i -p "Mount Point")"		# Prompt user to select mount point
	if [ -z "${_point_select}" ]; then return; fi						# Break if no point point selected
	if [ ! -d "${_point_select}" ]; then							# If selected mount point doesn't exist
		mdc="$(printf '%s\b' "No" "Yes" | dmenu-xres.sh -i -p "Create ${_point_select}?")"	# Prompt user to create directory
		if [ -z "${mdc}" ] || [[ "${mdc,,}" != "yes" ]]; then return; fi		# Break if creation not allowed
		mkdir --parents "${_point_select}"						# Create mount point
	fi

	# Mount Device
	sudo mount "${_dev_select}" "${_point_select}"

	# If mount failed, notify user
	if (($?)); then
		if ! command -v "notify-send" >/dev/null; then 
			printf '%s\n' "Failed to mount ${_dev_select} to ${_point_select}"
			return 1
		fi
		notify-send "Failed to mount ${_dev_select} to ${_point_select}"
		return 1
	fi
	return 0
}

# Unmount Device
umountdev() {
	if pgrep -x dmenu >/dev/null; then return; fi						# Break if dmenu is currently running
	local _dev_avail _dev_select								# Declare local variables

	# Get Devices available for unmounting
	_dev_avail="$(lsblk --list --paths | grep --invert-match --extended-regexp "(\/boot\/efi|\[SWAP\]|\/(home)?)$" | awk '/part \/.*$/ {print $1, "(" $4 ")"}')"

	# Get device selection from user
	_dev_select="$(echo "${_dev_avail}" | dmenu-xres.sh -i -p "Unmount which drive?" | awk '{print $1}')"
	if [ -z "${_dev_select}" ]; then return; fi						# Break if nothing chosen

	# Unmount Device
	sudo umount "${_dev_select}"

	# If unmount failed, notify user
	if (($?)); then
		if ! command -v "notify-send" >/dev/null; then
			printf '%s\n' "Failed to unmount ${_dev_select}"
			return 1
		fi
		notify-send "Failed to unmount ${_dev_select}"
		return 1
	fi
	return 0
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
