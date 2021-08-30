#!/bin/env bash
# shellcheck disable=SC2009,SC2164
#
# bash_functions
#
# A collection of useful functions

# Find processes by POSIX regex :: String pattern ...
pps() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        printf '%s\n' "Find running processes by pattern" "${FUNCNAME[0]} [-h|--help] PATTERN [...]"
        return
    fi

    ps aux | grep "${@}" | sed '/grep/d'
}

# Find processes by extended regex :: String regex ...
ppse() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        printf '%s\n' "Find running processes by regex" "${FUNCNAME[0]} [-h|--help] REGEX [...]"
        return
    fi
    ps aux | grep --extended-regexp "${@}" | sed '/grep/d'
}

# Get a cheat-sheet for a command :: String command
cheat() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        printf '%s\n' "Get cheat-sheet for a command" "${FUNCNAME[0]} [-h|--help] COMMAND"
        return
    fi
    curl --silent --fail "cheat.sh/${*}"
}

# Get the definition for a word or phrase :: String word
dict() {
    if [[ "${*,,}" =~ -(h|--help) ]]; then
        printf '%s\n' "Get the definition for a word or phrase" "${FUNCNAME[0]} [-h|--help] WORD"
        return
    fi
    curl --silent --fail "dict://dict.org/d:${*}"
}

# Clone a github repository by owner/repo :: String repository, [String path]
ghc() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        printf '%s\n' "Clone a github repository" "${FUNCNAME[0]} [-h|--help] REPOSITORY [PATH]"
        return
    fi
    git clone "git@github.com:${1}.git" "${2:-${1##*\/}}"
}

# Clone a gitlab repository by owner/repo :: String repository [String path]
glc() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        printf '%s\n' "Clone a gitlab repository" "${FUNCNAME[0]} [-h|--help] REPOSITORY [PATH]"
        return
    fi
    git clone "gi@gitlab.com:${1}.git" "${2:-${1##*\/}}"
}

# Make a directory if it doesn't exist, then change to it :: String path
mkcd() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        printf '%s\n' "Make a directory if necessary, then change to it" "${FUNCNAME[0]} [-h|--help] PATH"
        return
    fi
    mkdir --parents "${1}" && cd "${1}"
}

# Make today's working directory if it doesn't exist, then change to it
mdot() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        printf '%s\n' "Make today's working directory if necessary, then change to it" "${FUNCNAME[0]} [-h|--help]"
        return
    fi
    mkdir --parents "${HOME}/working/$(date --iso-8601)"
    cd "${_}"
}

# GFM Preview :: String gfmPath
mdp() {
    local pdf
    pdf="$(mktemp).pdf"
    pandoc --from="gfm" --to="pdf" --output="${pdf}" "${*}"
    "${VIEWER}" "${pdf}"
    rm --force "${pdf}"
}
