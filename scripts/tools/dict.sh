#!/usr/bin/env bash
#
# Simple wrapper for curling dict.org

# Handle arguments
if [[ "${*,,}" =~ -(h|-help) ]]; then
    cat << EOF
Simple wrapper for curling dict.org WORD

USAGE: ${0##*/} [OPTIONS] WORD

OPTIONS:
    -h, --help      Show this help message
EOF
    exit
fi

# Require word/phrase
if [ -z "${*}" ]; then
    printf '%s\n' "ERROR: No word/phrase specified" >&2
    exit 1
fi

curl --silent --fail "dict://dict.org/d:${*}"
