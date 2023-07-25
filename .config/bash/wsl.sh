#!/usr/bin/env bash
#
# Start wsl-vpnkit for DNS & Networking support with VPNs...
# https://github.com/sakai135/wsl-vpnkit

vpnkit() {
    command -v "wsl.exe" &>/dev/null || return
    wsl.exe --list | grep --quiet 'wsl-vpnkit' || return
    wsl.exe --distribution "wsl-vpnkit" "service wsl-vpnkit start"
}

vpnkit
unset -f vpnkit
