#!/usr/bin/env bash
#
# networkchk.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
# Date: 	2020-04-10
# 
# Check status of network connections: wifi, ethernet & bluetooth

# Clear Memory
trap "unset string" EXIT

# Handle Arguments
[[ "${@}" =~ -(h|-help) ]] && { printf '%s\n' "networkchk.sh [-b|--bluetooth]"; exit; }
[[ "${@}" =~ -(bt?|bluetooth) ]] && [ -s "/usr/lib/systemd/system/bluetooth.service" ] && \
	{ systemctl is-active --quiet bluetooth && systemctl stop bluetooth || systemctl start bluetooth; exit; }

# Get Status String
declare string
ip route |& sed --quiet '/^[0-9]/p' | grep --quiet --ignore-case "dev w" && string+=" "
ip route |& sed --quiet '/^[0-9]/p' | grep --quiet --ignore-case "dev e" && string+=" "
[ -s "/usr/lib/systemd/system/bluetooth.service" ] && systemctl --quiet is-active bluetooth && string+=" "

# Print Status
[ -n "${string}" ] && printf '%s\n' "${string:-1}"
