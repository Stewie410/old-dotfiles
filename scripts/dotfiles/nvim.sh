#!/usr/bin/env bash
#
# Download and install latest stable Neovim AppImage

show_help() {
    cat << EOF
Download and install latest stable Neovim AppImage

USAGE: ${0##*/} [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -c, --cache PATH        Download the file to PATH (default: '${defaults['cache']}')
    -d, --download-only     Only download the AppImage to Cache (see -c)
    -b, --bin PATH          Install AppImage to PATH (default: '${defaults['bin']}')
EOF
}

download() {
    local uri
    uri='https://github.com/neovim/neovim/releases/download/stable/nvim.appimage'

    mkdir --parents "${1%/*}"

    curl --silent --fail --location --output "${1}" "${uri}" && return 0

    printf '%s\n' "Failed to download AppImage to cache: '${1}'" >&2
    return 1
}

install_nvim() {
    mkdir --parents "${2%/*}"
    install --verbose "${1}" "${2}"
}

main() {
    local -A defaults settings
    local opts i
    opts="$(getopt \
        --options hdc:b: \
        --longoptions help,download-only,cache:,bin: \
        --name "${0##*/}" \
        -- "${@}" \
    )"

    defaults['cache']="${XDG_CACHE_HOME:-${HOME}/.cache}/nvim.appimage"
    defaults['bin']="/usr/local/bin/nvim"

    for i in "${!defaults[@]}"; do settings["${i}"]="${defaults["${i}"]}"; done

    eval set -- "${opts}"
    while true; do
        case "${1}" in
            -h | --help )           show_help; return 0;;
            -d | --download-only )  settings['no-install']="1";;
            -c | --cache )          settings['cache']="${2}"; shift;;
            -b | --bin )            settings['bin']="${2}"; shift;;
            -- )                    shift; break;;
            * )                     break;;
        esac
        shift
    done

    if (( EUID != 0 )); then
        printf '%s\n' "Script requires root priveledges" >&2
        return 1
    fi

    download "${settings['cache']}" || return
    [[ -n "${settings['no-install']}" ]] && return
    install "${settings['cache']}" "${settings['bin']}"
}

main "${@}"
