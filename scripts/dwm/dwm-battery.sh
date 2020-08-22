#!/usr/bin/env bash
#
# Display Battery Charge (%) + charge status icon

trap "unset battery capacity stat warn icon" EXIT
find "/sys/class/power_supply" -mindepth 1 -maxdepth 1 -wholename "*BAT*" -exec readlink --canonicalize {} + | while read -r battery; do
    capacity="$(cat "${battery}/capacity" 2>/dev/null)" || break
    grep --quiet "^Charging" "${battery}/status" && stat=""
    ((capacity <= 24)) && { warn="!"; icon=""; }
    ((capacity >= 25)) && icon=""
    ((capacity >= 50)) && icon=""
    ((capacity >= 75)) && icon=""
    ((capacity >= 95)) && icon=""
    printf '%s%s%s %s%%' "${warn}" "${stat}" "${icon}" "${capacity}"
done
