#!/usr/bin/env bash

getLinuxIP() {
    ip a | awk '
        /inet/ && ! /:/ && ! /127\.0\.0\.1/ {
            print gensub(/\/.*$/, "", 1, $2)
        }
    '
}

getWindowsIP() {
    ip r | awk '
        /^default/ {
            print $3
        }
    '
}

main() {
   /mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Start-Process netsh.exe -ArgumentList \"advfirewall firewall add rule name=X11-Forwarding dir=in action=allow program=%ProgramFiles%\\VcXsrv\\vcxsrv.exe localip=$(getWindowsIP) remoteip=$(getLinuxIP) localport=6000 protocol=tcp\" -Verb RunAs"
}

# Require root access
if ((EUID != 0)); then
    printf '%s\n' "Permission denied: Script requires elevated priviledges" >&2
    exit 1
fi

main
