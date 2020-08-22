#!/usr/bin/env bash
#
# Display Network/Radio status

# Click Events
case "${BLOCK_BUTTON}" in
    1 )     setsid --force "${TERMINAL}" --command nmtui;;
    2 )
            if systemctl --quiet is-active bluetooth; then
                systemctl stop bluetooth
            else
                systemctl start bluetooth
            fi
            ;;
    3 )     setsid --fork "${TERMINAL}" --command bluetoothctl;;
esac

# Get Status
{
    ip route | \
        tr '[:upper:]' '[:lower:]' | \
        grep --ignore-case "scope" | \
        awk '/dev w/{print ""}/dev e/{print ""}/dev t/{print ""}'
    systemctl --quiet is-active bluetooth && echo ""
} | paste --serial --delimiter=" "
