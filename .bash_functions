#!/bin/env bash
#
# bash_functions
# Author:	Alex Paarfus <stewie410@me.com>
#
# A collection of useful functions

# ##----------------------------------------------------##
# #|			    Process Management		            |#
# ##----------------------------------------------------##
pps() { for i in "${@}"; do pgrep "${i}"; done; }

# ##----------------------------------------------------##
# #|			        Device Mounting			        |#
# ##----------------------------------------------------##
dmenu_mount() {
    # Return on Error
    pidof dmenu >/dev/null && return 1

    # Declare local variables
    local menu dev pnt md

    # Define dmenu location
    menu="$(command -v dmenu-xres.sh || command -v dmenu)"

	# Get Device
    dev="$(lsblk --list --paths | \
        awk '/part *$/ {print $1 " (" $4 ")"}' | \
        "${menu}" -i -p "Mount Device")"
    [ -n "${dev}" ] || return 1
    dev="${dev##* }"

    # Mount device as per fstab or user
    if grep --quiet "${dev}" "/etc/fstab"; then
        sudo mount "${dev}" && { notify-send "Mounted '${dev}'"; return; }
        notify-send --urgency="critical" "Failed to mount '${dev}'"
        return 1
    fi

    # Get mount point
    pnt="$(find /mnt /media /mount "${HOME}" -maxdepth 1 -type d | \
        "${menu}" -i -p "Mount Point")"
    [ -n "${pnt}" ] || return 1
    pnt="${pnt##* }"

    # Create Moiunt Point
    if [ ! -d "${pnt}" ]; then
        md="$(printf '%s\n' "No" "Yes" | \
            "${menu}" -i -p "Create '${pnt}'?")"
        [[ "${md,,}" =~ ^y ]] || return 1
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
    dev="$(mount | \
        sed '/^[^\/]/d;/boot/d' | \
        awk '{print $1 " (" $3 ")"}')"
    [ -n "${dev}" ] || return 1
    dev="${dev##* }"

	# Unmount Device
    sudo umount "${dev}" && { notify-send "Unmounted '${dev}'"; return; }
    notify-send --urgency="critical" "Failed to unmount '${dev}'"
    return 1
}

# ##----------------------------------------------------##
# #|			Curl Utilities			|#
# ##----------------------------------------------------##
cheat() { curl --silent --fail "cheat.sh/${*}"; }
dict() { curl --silent --fail "dict://dict.org/d:${*}"; }

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
    if [ -z "${1}" ] || [ ! -f "${1}" ]; then
        printf '%s\n' "USAGE: extract <archive>"
        return 1
    fi

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
            *.zip )                 u="$(command -v unzip)";;
            *.Z )                   u="$(command -v uncompress)";;
            *.7z )                  u="$(command -v 7z)"; a="x ";;
            * )                     printf 'Invalid File:\t%s\n' "${i}"; continue;;
        esac

        # Extract File
        eval "${u}" "${a}\"${i}\""
    done
}

# ##----------------------------------------------------##
# #|        Make Directory && Change Directory          |#
# ##----------------------------------------------------##
mkcd() {
    mkdir --parents "${1}"
    cd "${1}" || return 1
}
