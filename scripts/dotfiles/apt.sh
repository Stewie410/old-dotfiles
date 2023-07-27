#!/usr/bin/env bash
#
# Download and install non-default packages

show_help() {
    cat << EOF
Download and install non-default packages

USAGE: ${0##*/} [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -s, --show          Print app list, rather than installing
    -U, --no-update     No update/upgrade before installing packages
EOF
}

is_root() {
    (( EUID == 0 )) && return 0
    printf '%s\n' "${0##*/} requires root priviledges" >&2
    return 1
}

get_list() {
    curl \
        --silent \
        --fail \
        --location \
        'https://raw.githubusercontent.com/Stewie410/dotfiles/wsl2/scripts/dotfiles/pkg'
}

update() {
    apt-get update
    apt-get upgrade --yes
}

install_packages() {
    local -a pkgs

    if ! mapfile -t pkgs < <(get_list); then
        printf '%s\n' "Failed to download package list" >&2
        return 1
    fi

    apt-get install --yes "${pkgs[@]}"
}

main() {
    local opts no_update
    opts="$(getopt \
        --options hsU \
        --longoptions help,show,no-update \
        --name "${0##*/}" \
        -- "${@}" \
    )"

    eval set -- "${opts}"
    while true; do
        case "${1}" in
            -h | --help )       show_help; return 0;;
            -U | --no-update )  no_update="1";;
            -s | --show )       get_list; return;;
            -- )                shift; break;;
            * )                 break;;
        esac
        shift
    done

    is_root || return

    [[ -z "${no_update}" ]] && update

    install_packages
}

main "${@}"
