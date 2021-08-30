#!/usr/bin/env bash
#
# Display Network/Radio status

getNetworkIcons() {
    ip route | awk '
        /scope/ {
            if (match($0, "dev w"))
                print ""
            else if (match($0, "dev e"))
                print ""
            else if (match($0, "dev t"))
                print ""
        }
    '
}

getRadioIcons() {
    systemctl --quiet is-active bluetooth && printf '%s\n' ""
}

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

{ getNetworkIcons; getRadioIcons; } | \
    paste --serial --delimiter=" " | \
    tr -d '\n'
