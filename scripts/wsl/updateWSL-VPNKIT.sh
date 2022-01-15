#!/usr/bin/env bash

path="/mnt/c/Users/alex/Downloads"
trap 'unset path' EXIT

if ! [ -d "${path}" ] || (( "$(find "${path}" -type f -name "*wsl-vpnkit.tar.gz" | wc --lines)" )); then
    printf '%s\n' "ERROR: Missing wsl-vpnkit image: '${path}/wsl-vpnkit.tar.gz'" >&2
    exit 1
fi

pushd "${path}" || exit 1
wsl.exe --unregister wsl-vpnkit
wsl.exe --import wsl-vpnkit /mnt/c/Users/Alex/wsl-vpnkit /mnt
wsl.exe -d wsl-vpnkit service wsl-vpnkit start
