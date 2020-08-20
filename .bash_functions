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
extract() { for i in "${@}"; do "${HOME}/scripts/tools/extract_archive.sh" "${i}"; done; }

# Make and change to directory :: String path
mkcd() { mkdir --parents "${1}" && cd "${1}"; }

# Make and change to Today's working directory
mdot() { local d; d="${HOME}/working/$(date --iso-8601)"; mkdir --parents "${d}" && cd "${d}"; }
