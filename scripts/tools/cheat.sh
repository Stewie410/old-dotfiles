#!/usr/bin/env bash
#
# Simple wrapper for curling cheat.sh

if [[ "${*,,}" =~ -(h|-help) ]]; then
    cat << EOF
Simple wrapper for curling cheat.sh

USAGE: ${0##*/} [OPTIONS] [COMMAND]

OPTIONS:
    -h, --help      Show this help message
EOF
    exit
fi

curl --silent --fail "cheat.sh/${*}"
