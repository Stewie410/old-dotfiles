#!/bin/env bash
# shellcheck disable=SC2009,SC2164
#
# bash_functions
#
# A collection of useful functions

# Find Processes
pps() { for i in "${@}"; do ps aux | grep "${i}" | sed '/grep/d'; done; }
ppse() { for i in "${@}"; do ps aux | grep --extended-regexp "${i}" | sed '/grep/d'; done; }

# Curl Utilities
cheat() { for i in "${@}"; do curl --silent --fail "cheat.sh/${i}"; done; }
dict() { for i in "${@}"; do curl --silent --fail "dict://dict.org/d:${i}"; done; }

# Github Cloning
ghc() { git clone "https://github.com/${1}.git" "${2:-1${1##*\/}}"; }
ghcl() { for i in "${@}"; do git clone "https://github.com/${i}.git" "${i##*\/}"; done; }

# Gitlab
glc() { git clone "https://gitlab.com/${1}.git" "${2:-1${1##*\/}}"; }
glcl() { for i in "${@}"; do git clone "https://gitlab.com/${i}.git" "${i##*\/}"; done; }

# Archive Extracting
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

# Make and change to directory :: String path
mkcd() { mkdir --parents "${1}" && cd "${1}"; }

# Make and change to Today's working directory
mdot() { local d; d="${HOME}/working/$(date --iso-8601)"; mkdir --parents "${d}" && cd "${d}"; }
