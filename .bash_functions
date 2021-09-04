#!/bin/env bash
#
# A collection of useful functions

# Make a directory if it doesn't exist, then change to it :: String path
mkcd() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        cat << EOF
Make a directory if necessary, then change to it

USAGE: ${FUNCNAME[0]} [OPTIONS] PATH

OPTIONS:
    -h, --help      Show this help message
EOF
        return
    fi

    # shellcheck disable=SC2164
    mkdir --parents "${*}" && cd "${*}"
}

# Make today's working directory if it doesn't exist, then change to it
mdot() {
    mkcd "${HOME}/working/$(date --iso-8601)"
}

# Make yesterday's working directory if it doesn't exist, then change to it
mdoy() {
    mkcd "${HOME}/working/$(date --date="yesterday" --iso-8601)"
}

# Make DATE's working directory if it doesn't exist, then change to it
mdod() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        cat << EOF
Make DATE's working directory if necessary, then change to it

USAGE: ${FUNCNAME[0]} [OPTIONS] DATE

OPTIONS:
    -h, --help      Show this help message
EOF
        return
    fi

    mkcd "${HOME}/working/$(date --date="${*}" --iso-8601)"
}

# Preview Github-Flavored Markdown file
gfmp() {
    if [[ "${*,,}" =~ -(h|-help) ]]; then
        cat << EOF
Preview a Github-Flavored Markdown (GFM) file as a PDF

USAGE: ${FUNCNAME[0]} [OPTIONS] FILE

OPTIONS:
    -h, --help      Show this help message
EOF
        return
    fi

    local pdf
    pdf="$(mktemp)"
    pandoc --from=gfm --to=pdf --output="${pdf}" "${*}"
    "${VIEWER}" "${pdf}"
    rm --force "${pdf}"
}
