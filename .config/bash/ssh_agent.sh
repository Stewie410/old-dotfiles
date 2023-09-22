#!/usr/bin/env bash
#
# Forward SSH auth requests to Windows or fallback to Keychain
# If neither are available, warn user

if (command -v socat && command -v npiperelay.exe) &>/dev/null; then
    if ! pgrep --full 'npiperelay\.exe.*openssh-ssh-agent' &>/dev/null; then
        [[ -S "${SSH_AUTH_SOCK}" ]] && rm --force "${SSH_AUTH_SOCK}"
        listen="UNIX-LISTEN:${SSH_AUTH_SOCK},fork"
        relay="EXEC:'npiperelay.exe -ei -s //./pipe/openssh-ssh-agent',nofork"
        (setsid socat "${listen}" "${relay}" & disown) &>/dev/null
        unset listen relay
    fi
elif command -v keychain &>/dev/null; then
    eval "$(keychain --eval --agents 'ssh' "${SSH_HOME}/id_rsa")"
else
    printf '%s\n' "Failed to configure ssh-agent" >&2
fi
