#!/usr/bin/env bash

getCurrentLocalIP() {
    ip a | awk '
        /inet/ && ! /:/ && ! /127\.0\.0\.1/ {
            print gensub(/\/.*$/, "", 1, $2)
        }
    '
}

getCurrentRemoteIP() {
    ip r | awk '
        /^default/ {
            print $3
        }
    '
}

getLastIP() {
    local type
    type="Local"
    [ -n "${1}" ] && type="Remote"

    netsh.exe advfirewall firewall show rule name="X11-Fordwarding" | \
        awk --assign "type=${type}" '
            match($0, type "IP") {
                print gensub(/\/.*$/, "", 1, $2)
            }
        '
}

main() {
    local curWinIP curNixIP preWinIP preNixIP
    curWinIP="$(getCurrentRemoteIP)"
    curNixIP="$(getCurrentLocalIP)"
    preWinIP="$(getLastIP 1)"
    preNixIP="$(getLastIP)"

    if [[ "${curWinIP}" != "${preWinIP}" ]] || [[ "${curNixIP}" != "${preNixIP}" ]]; then
        /mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Start-Process netsh.exe -ArgumentList \"advfirewall firewall set rule name=X11-Forwarding new localip=${curWinIP} remoteip=${curNixIP} \" -Verb RunAs"
    fi

    printf '%s\n' "${curWinIP}:0"
}

main
