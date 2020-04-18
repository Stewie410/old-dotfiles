#!/bin/env bash
#
# bash_functions
# Author:	Alex Paarfus <stewie410@me.com>
#
# A collection of useful functions

# ##----------------------------------------------------##
# #|			    Process Management		            |#
# ##----------------------------------------------------##
pps() {
    for i in "${@}"; do
        ps aux | \
            grep "${i}" | \
            grep --invert-match "grep"
    done
}
ppse() {
    for i in "${@}"; do
        ps aux | \
            grep --extended-regexp "${i}" | \
            grep --invert-match "grep"
    done
}

# ##----------------------------------------------------##
# #|			        Device Mounting			        |#
# ##----------------------------------------------------##
dmenu_mount() {
    # Return on Error
    command -v dmenu >/dev/null || return
	pgrep -x dmenu >/dev/null && return 1

    # Declare local variables
    local menu dev pnt md

    # Define dmenu location
    menu="$(command -v dmenu-xres.sh || command -v dmenu)"

	# Get Device
    lsblk --list --paths | \
        awk '/part *$/ {print $1 " (" $4 ")"}' | \
        "${menu}" -i -p "Mount Device" | \
        read -rt 60 dev || return
    dev="${dev##* }"

    # Mount device as per fstab or user
    if grep --quiet "${dev}" "/etc/fstab"; then
        sudo mount "${dev}" && { notify-send "Mounted '${dev}'"; return; }
        notify-send --urgency="critical" "Failed to mount '${dev}'"
        return 1
    fi

    # Get mount point
    find "/mnt" "/media" "/mount" "${HOME}" -maxdepth 1 -type d | \
        "${menu}" -i -p "Mount Point" | \
        read -rt 60 pnt || return
    pnt="${pnt##* }"

    # Create Moiunt Point
    if [ ! -d "${pnt}" ]; then
        printf '%s\n' "No" "Yes" | "${menu}" -i -p "Create '${pnt}'?" | \
            read -rt 15 || return
        [[ "${md,,}" =~ ^y ]] || return
        mkdir --parents "${pnt}" || \
            sudo mkdir --parents "${pnt}" || \
            { notify-send "Failed to create mount point"; return 1; }
    fi

    # Mount Device
    sudo mount "${dev}" "${pnt}" && \
        { notify-send "Mounted '${dev}' -> '${pnt}'"; return; }
    notify-send --urgency="critical" "Failed to mount '${dev}' -> '${pnt}'"
    return 1
}

dmenu_umount() {
    # Return on Error
    command -v dmenu >/dev/null || return
	pgrep -x dmenu >/dev/null || return

    # Declare local variables
    local menu dev

    # Define dmenu location
    menu="$(command -v dmenu-xres.sh || command -v dmenu)"

	# Get Device to unmount
    mount | sed '/^[^\/]/d;/boot/d' | awk '{print $1 " (" $3 ")"}' | \
        "${menu}" -i -p "Unmount Device" | \
        read -rt 60 dev || return
    dev="${dev##* }"

	# Unmount Device
    sudo umount "${dev}" && { notify-send "Unmounted '${dev}'"; return; }
    notify-send --urgency="critical" "Failed to unmount '${dev}'"
    return 1
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
    ( [ -n "${1}" ] && [ -f "${1}" ] ) || \
        { printf '%s\n' "USAGE: extract <archive>"; return 1; }

    # Process all arguments
    for i in "${@}"; do
        # Declare local variables
        local u a

        # Determine Utility & Args
        case "${1}" in
            *.tar.bz2 | *.tbz2 )    u="$(command -v tar)"; a="--extract --bzip2 --file=";;
            *.tar.gz | *.tgz )      u="$(command -v tar)"; a="--extract --gzip --file=";;
            *.tar )                 u="$(command -v tar)"; a="--extract --file=";;
            *.bz | *.bz2 )          u="$(command -v bunzip2)"; a="--decompress ";;
            *.gz )                  u="$(command -v gunzip)"; a="--decompress ";;
            *.rar )                 u="$(command -v unrar)";;
            *.Z )                   u="$(command -v uncompress)";;
            *.7z )                  u="$(command -v 7z)"; a="x ";;
        esac

        # Return if utility not found
        [ -n "${u}" ] || \
            { printf 'Invalid File:\t%b\n' "${i}"; continue; }

        # Extract File
        exec "${u} ${a}\"${i}\""
    done
}

# ##----------------------------------------------------##
# #|        Make Directory && Change Directory          |#
# ##----------------------------------------------------##
mkcd() { mkdir --parents "${1}" && cd "${1}"; }
