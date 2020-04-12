#!/bin/env bash
#
# dmenu_sudo-xres.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-12
#
# dmenu_run, but colors from wpg's Xresouces template
# Requires:
#	-dmenu

# Clear Memory
trap "unset xres nbg nfg sbg sfg" EXIT

# Return if required commands not found
command -v dmenu_run >/dev/null || exit 1

# Get Colors
xres="${HOME}/.Xresources"
nbg="$(awk '/^\*\.color0:/ {print $NF}' "${xres}")"
nfg="$(awk '/^\*\.color4:/ {print $NF}' "${xres}")"
sbg="$(awk '/^\*\.color8:/ {print $NF}' "${xres}")"
sfg="$(awk '/^\*\.color11:/ {print $NF}' "${xres}")"

# Run Dmenu
dmenu_run -nb "${nbg}" -nf "${nfg}" -sb "${sbg}" -sf "${sfg}" "${@}" <&- && echo
