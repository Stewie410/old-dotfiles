#!/usr/bin/env bash
#
# Display Battery Charge (%) + charge status icon

find "/sys/class/power_supply" -mindepth 1 -maxdepth 1 -name "*BAT*" -exec readlink --canonicalize {} + | while read -r battery
do
    awk --field-separator "=" '
        function getCapacityIcon(level,    ico) {
            ico = ""
            if (level >= 25)
                ico = ""
            if (level >= 50)
                ico = ""
            if (level >= 75)
                ico = ""
            if (level >= 95)
                ico = ""
            return ico
        }

        function getStatusIcon(state,    icon) {
            ico = ""
            if (state == "Charging")
                ico = ""
            return ico
        }

        function getWarningIcon(level,    ico) {
            ico = ""
            if (capacity < 25)
                ico = "!"
            return ico
        }

        /_CAPACITY=/ { capacity = $NF }
        /_STATUS=/ { status = getStatusIcon($NF) }
        END {
            printf "%s%s%s %s%%\n", getWarningIcon(capacity), status, getCapacityIcon(capacity), capacity
        }
    ' < "${battery}/uevent"
done | paste --serial --delimiter="|" | sed 's/|/ | /g' | tr -d '\n'
