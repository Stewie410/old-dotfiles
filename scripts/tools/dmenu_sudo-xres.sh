#!/bin/env bash
#
# dmenu_sudo-xres.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-03
#
# dmenu_run, but colors from Xresoures
# Requires:
#	-dmenu
#	-wpg

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Get Normal BG from Xresources
getXResNB() { grep --ignore-case --fixed-strings "*.background" "${HOME}/.config/wpg/formats/colors.Xresources" | cut --fields=2 --delimiter='#'; }

# Get Normal FG from Xresources
getXResNF() { grep --ignore-case --fixed-strings "*.foreground" "${HOME}/.config/wpg/formats/colors.Xresources" | cut --fields=2 --delimiter='#'; }

# Get the Selected BG from Xresources
getXResSB() { grep --ignore-case --fixed-strings "*.color4" "${HOME}/.config/wpg/formats/colors.Xresources" | cut --fields=2 --delimiter='#'; }

# Get the Selected FG from Xresources
getXResSF() { grep --ignore-case --fixed-strings "*.color15" "${HOME}/.config/wpg/formats/colors.Xresources" | cut --fields=2 --delimiter='#'; }

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
if ! command -v dmenu_run >/dev/null 2>&1; then printf '%b\n' "ERROR:\tCannot locate command:\tdmenu_run"; exit 1; fi
if ! command -v wpg >/dev/null 2>&1; then printf '%b\n' "ERROR:\tCannot located command:\twpg"; exit 1; fi
if [ ! -s "${HOME}/.config/wpg/formats/colors.Xresources" ]; then printf "ERROR:\tCannot located WPG Xresources colors"; exit 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
dmenu_run -nb "#$(getXResNB)" -nf "#$(getXResNF)" -sb "#$(getXResSB)" -sf "#$(getXResSF)" -fn "Monospace-10" -p "Password: " "${@}" <&- && echo
