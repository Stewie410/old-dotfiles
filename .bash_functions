#!/bin/env bash
#
# bash_functions
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2020-04-11
#
# A collection of useful functions

# ##----------------------------------------------------##
# #|			Process Management		|#
# ##----------------------------------------------------##
pps() { ps aux | grep "${@}" | grep --invert-match "grep"; }
ppse() { px aux | grep --extended-regexp "${@}" | grep --invert-match "grep"; }

# ##----------------------------------------------------##
# #|			Device Mounting			|#
# ##----------------------------------------------------##
dmenu_mount() {
	# Return if dmenu already running
	pgrep -x dmenu >/dev/null && return

	# Declare local variables
	local dev pnt

	# Get Device from User
	dev="$(lsblk --list --paths | \
		awk '/part *$/ {print $1 " (" $4 ")"}' | \
		dmenu-xres.sh -i -p "Mount Device" | \
		sed 's/ ([^)]*)$//')"
	[ -n "${dev}" ] || return
	
	# Mount if entry in fstab
	grep --quiet "${dev}" "/etc/fstab" && { sudo mount "${dev}"; return; }

	# Get Mount Point
	pnt="$(find /mnt /media /mount "${HOME}" -maxdepth 1 ! -wholename "*.*" -type d | \
		dmenu-xres.sh -i -p "Mount Point")"
	[ -n "${pnt}" ] || return
	if [ ! -d "${pnt}" ]; then
		printf '%s\n' "No" "Yes" | \
			dmenu-xres.sh -i -d "Create '${pnt}'?" | \
			grep --quiet --ignore-case "y" || return
		mkdir --parents "${pnt}"
	fi

	# Mount Device
	sudo mount "${dev}" "${pnt}" || \
		notify-send --urgency="normal" "Mount Failed: '${dev}' --> '${pnt}'" 2>/dev/null
}

dmenu_umount() {
	# Return if dmenu already running
	pgrep -x dmenu >/dev/null || return

	# Get Device to unmount
	local dev
	dev="$(lsblk --list --paths | \
		sed '/\/|boot\|efi\|SWAP\|home/d' | \
		awk '/part *\/.*$/ {print $1 " (" $4 ")"}' | \
		dmenu-xres.sh -i -p "Unmount Device" | \
		sed 's/ ([^)]*)$//')"
	[ -n "${dev}" ] || return

	# Unmount Device
	sudo umount "${dev}" || \
		notify-send --urgency="normal" "Unmount Failed: '${dev}'" 2>/dev/null
}

# ##----------------------------------------------------##
# #|			Curl Utilities			|#
# ##----------------------------------------------------##
cheat() { curl --silent --fail "cheat.sh/${@}"; }
dict() { curl --silent --fail "dict://dict.org/d:${@}"; }

# ##----------------------------------------------------##
# #|			Git Cloning			|#
# ##----------------------------------------------------##
# Clone Git(hub|lab) repository to current directory
ghcl() { for i in "${@}"; do git clone "https://github.com/${i}.git"; done; }
glcl() { for i in "${@}"; do git clone "https://gitlab.com/${i}.git"; done; }

# ##----------------------------------------------------##
# #| 			Archives 			|#
# ##----------------------------------------------------##
extract() {
	# Return if no args passed
	[ -n "${1}" ] || return

	# Process all arguments
	for i in "${@}"; do
		# Declare local variables
		local u a

		# Determine Utility
		case "${i}" in
			*.tar.bz2 | *.tbz2 ) 	u="$(command -v tar)"; a="--extract --bzip2 --file=\"${i}\"";;
			*.tar.gz | *.tgz ) 	u="$(command -v tar)"; a="--extract --gzip --file=\"${i}\"";;
			*.bz2 ) 		u="$(command -v bunzip2)"; a="${i}";;
			*.rar ) 		u="$(command -v unrar)"; a="${i}";;
			*.gz ) 			u="$(command -v gunzip)"; a="${i}";;
			*.tar ) 		u="$(command -v tar)"; a="--extract --file=\"${i}\"";;
			*.zip ) 		u="$(command -v unzip)"; a="${i}";;
			*.Z ) 			u="$(command -v uncompress)"; a="${i}";;
			*.7z ) 			u="$(command -v 7z)"; a="x \"${i}\"";;
		esac

		# Return if utility not found
		[ -n "${u}" ] || { printf 'Invalid File:\t%s\n' "${i}"; continue; }

		# Extract File
		exec "${u} ${a}"
	done
}
