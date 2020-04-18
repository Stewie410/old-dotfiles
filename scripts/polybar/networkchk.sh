#!/usr/bin/env bash
#
# networkchk.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
#
# Retrieve network/radio status & control bluetooth

# Declare Variables
declare string
trap "unset string" EXIT

# Handle Arguments
if [[ "${*}" =~ b(t|luetooth)? ]] && [ -s "/usr/lib/systemd/system/bluetooth.service}" ]; then
        if systemctl is-active --quiet bluetooth; then
            systemctl stop bluetooth
        else
            systemctl start bluetooth
        fi >/dev/null
fi

# Get Status
for i in $(ip route |& awk '/^[0-9]/ {print $3}'); do
    [[ "${i,,}" =~ ^w ]] && { string+=" "; continue; }
    [[ "${i,,}" =~ ^e ]] && { string+=" "; continue; }
    [[ "${i,,}" =~ ^t ]] && { string+=" "; continue; }
done
[ -s "/usr/lib/systemd/system/bluetooth.service" ] && { systemctl --quiet is-active bluetooth && string+=" "; }

# Print Status
printf '%s\n' "${string::-1}"
