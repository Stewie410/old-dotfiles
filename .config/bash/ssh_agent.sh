#!/usr/bin/env bash
#
# Forward SSH auth requests to Windows or fallback to Keychain
# If neither are available, warn user

relay() {
    local listen relay

    listen="UNIX-LISTEN:${SSH_AUTH_SOCK},fork"
    relay="EXEC:'npiperelay.exe -ei -s //./pipe/openssh-ssh-agent',nofork"

    (command -v "socat" && command -v "npiperelay.exe") &>/dev/null || return
    pgrep --full 'npiperelay\.exe.*openssh-ssh-agent' &>/dev/null && return
    rm --force "${SSH_AUTH_SOCK}"
    (setsid socat "${listen}" "${relay}" & disown) &>/dev/null
}

kc() {
    local kc

    command -v "keychain" &>/dev/null || return

    kc="$(keychain \
        --eval \
        --agents "ssh" \
        "${SSH_HOME}/id_rsa" \
        "${SSH_HOME}/github/id_rsa" \
        "${SSH_HOME}/gitlab/id_rsa" \
    )"

    eval "${kc}"
}

warn() {
    printf '%s\n' \
        "$(tput setaf 3)Failed to configure ssh-agent$(tput sgr0)" >&2
}

relay || kc || warn
unset -f relay kc warn
