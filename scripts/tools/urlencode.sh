#!/usr/bin/env bash
#
# Try to URL Encode text

show_help() {
    cat << EOF
Try to URL Encode text

USAGE: ${0##*/} [OPTIONS] STRING

OPTIONS:
    -h, --help      Show this help message
    -c, --curl      Use cURL to encode (default)
    -P, --perl      Use perl to encode
    -j, --jq        Use jq to encode
    -x, --xxd       Use xxd to encode
EOF
}

curl_enc() {
    curl \
        --get \
        --silent \
        --output '/dev/null' \
        --write-format '%{url_effective}' \
        --data-urlencode @- \
        "" | \
    cut \
        --characters="3-"
}

perl_enc() {
    perl -MURI::Escape -e 'print uri_escape($ARGV[0])' "${1}"
}

jq_enc() {
    jq --slurp --raw-input --raw-output '@uri' <<< "${1}"
}

xxd_enc() {
    xxd -p <<< "${1}" | \
        tr -d '\n' | \
        sed 's/../%&/g'
}

main() {
    local opts tool
    opts="$(getopt \
        --options hcPjx \
        --longoptions help,curl,perl,jq,xxd \
        --name "${0##*/}" \
        -- "${@}" \
    )"

    tool="curl"

    eval set -- "${opts}"
    while true; do
        case "${1}" in
            -h | --help )       show_help; return 0;;
            -c | --curl )       tool="curl";;
            -p | --perl )       tool="perl";;
            -j | --jq )         tool="jq";;
            -x | --xxd )        tool="xxd";;
            -- )                shift; break;;
            * )                 break;;
        esac
        shift
    done

    if ! command -v "${tool}" &>/dev/null; then
        printf 'Missing required application: %s\n' "${tool}" >&2
        return 1
    fi

    while (( $# > 0 )); do
        case "${tool}" in
            curl )  curl_enc "${1}";;
            perl )  perl_enc "${1}";;
            jq )    jq_enc "${1}";;
            xxd )   xxd_enc "${1}";;
        esac
        shift
    done
}

main "${@}"
