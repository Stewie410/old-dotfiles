#!/usr/bin/env bash
#
# Forward SSH auth requests to Windows or Keychain

if (command -v 'socat' && command -v 'npiperelay.exe') &>/dev/null; then
    if ! pgrep --full 'npiperelay\.exe.*openssh-ssh-agent' &>/dev/null; then
        rm --force "${SSH_AUTH_SOCK}"
        listen="UNIX-LISTEN:${SSH_AUTH_SOCK},fork"
        relay="EXEC:'npiperelay.exe -ei -s //./pipe/openssh-ssh-agent',nofork"
        (setsid socat "${listen}" "${relay}" & disown) &>/dev/null
        unset listen relay
    fi
elif command -v keychain &>/dev/null; then
    eval "$(keychain --eval --agents 'ssh' "${SSH_HOME}/id_rsa")"
else
    printf 'Failed to configure wsl-ssh-agent\n' >&2
fi
