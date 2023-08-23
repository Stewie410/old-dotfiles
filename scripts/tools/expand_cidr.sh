#!/usr/bin/env bash
#
# Expand a CIDR address

show_help() {
    cat << EOF
Expand a CIDR Address

USAGE: ${0##*/} [OPTIONS] CIDR [...]
       ${0##*/} [OPTIONS] -

OPTIONS:
    -h, --help          Show this help message
EOF
}

is_valid() {
    local octet cidr
    octet='([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
    cidr='(/([1-9]|[12][0-9]|3[0-2]))?'

    [[ "${1}" =~ ^(${octet}\.){3}(${octet})${cidr} ]]
}

expand_cidr() {
    local a b c d mask current end
    IFS='.' read -r a b c d <<< "${1%/*}"

    mask="$(( (1 << (32 - ${1#*/})) - 1 ))"
    current="$(( ( (a << 24) + (b << 16) + (c << 8) + d) & ~mask ))"
    end="$(( current | mask ))"

    for (( ; current <= end; current++ )); do
        printf '%d.%d.%d.%d\n' \
            "$(( (current >> 24) & 0xFF ))" \
            "$(( (current >> 16) & 0xFF ))" \
            "$(( (current >> 8) & 0xFF ))" \
            "$(( current & 0xFF ))"
    done
}

main() {
    if [[ "${1,,}" =~ ^-(h|-help)$ ]]; then
        show_help
        return 0
    fi

    [[ -z "${1}" || "${1}" == "-" ]] && set -- '/dev/stdin'

    while (( $# > 0 )); do
        if ! is_valid "${1}"; then
            printf 'Invalid address format: %s\n' "${1}" >&2
        elif [[ "${1}" != */* ]]; then
            printf '%s\n' "${1}"
        else
            expand_cidr "${1}"
        fi
        shift
    done
}

main "${@}"
