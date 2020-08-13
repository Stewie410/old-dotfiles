#!/usr/bin/env bash
#
# dmenu_sudo-xres.sh
#
# dmenu_run, but with sudo & Xresources theme

# Run Dmenu
dmenu_run -fn "Fira Code Regular" \
    -nb "$(awk '/^\*\.color0:/ {print $NF}' "${HOME}/.Xresources")" \
    -nf "$(awk '/^\*\.color4:/ {print $NF}' "${HOME}/.Xresources")" \
    -sb "$(awk '/^\*\.color8:/ {print $NF}' "${HOME}/.Xresources")" \
    -sf "$(awk '/^\*\.color11:/ {print $NF}' "${HOME}/.Xresources")" \
    "${@}" <&- && echo
