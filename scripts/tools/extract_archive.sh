#!/usr/bin/env bash
#
# Extract various types of archive/compressed files

require() {
    command -v "${*}" >/dev/null
}

show_help() {
    cat << EOF
Extract various types of archive files to current directory

USAGE: ${0##*/} [OPTIONS] ARCHIVE

OPTIONS:
    -h, --help      Show this help message

SUPPORTED FORMATS
    tar | tar.xz
    tgz | tar.gz
    tbz | tbz2 | tar.bz | tar.bz2
    tzs | tzst | tar.zst
    bz2
    gz
    rar
    zip
    Z
    7z
    deb
EOF
}

getFormat() {
    awk '
        {
            format = gensub(/^[^.]+?\./, "", 1, $0)
            switch (format) {
                case /t(ar\.)?xz/: format = "tar"
                case /t(ar\.)?gz/: format = "tgz"
                case /t(ar\.)?bz2?/: format = "tbz2"
                case /t(ar\.)?zst?/: format = "tzst"
            }
            print format
        }
    ' <<< "${*,,}"
}

# Handle Arguments
OPTS="$(getopt --options h --longoptions help --name "${0##*/}" -- "${@}")"
eval set -- "${OPTS}"
while true; do
    case "${1}" in
        -h | --help )   show_help; exit 0;;
        -- )            shift; break;;
        * )             break;;
    esac
    shift
done

# Extract Archive
case "$(getFormat "${*}")" in
    tar )   require "tar" && tar --extract --file="${*}";;
    tgz )   require "tar" && require "gunzip" && tar --extract --gzip --file="${*}";;
    tbz2 )  require "tar" && require "bunzip2" && tar --extract --bzip2 --file="${*}";;
    tzst )  require "unzstd" && unzstd "${*}";;
    bz2 )   require "bunzip2" && bunzip2 --keep "${*}";;
    gz )    require "gunzip" && gunzip --keep "${*}";;
    rar )   require "unrar" && unrar x "${*}";;
    zip )   require "unzip" && unzip "${*}";;
    z )     require "uncompress" && uncompress "${*}";;
    7z )    require "7z" && 7z x "${*}";;
    deb )   require "ar" && ar x "${*}";;
    * )     printf '%s\n' "Unknown filetype: '${*}'"; exit 10;;
esac
