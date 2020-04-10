#!/bin/env bash
#
# dmenu_run-xres.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-10
#
# dmenu_run, but colors from wpg's Xresouces template
# Requires:
#	-dmenu
#	-wpg

# Clear Memory
trap "unset colors" EXIT

# Return if required commands not found
command -v dmenu_run >/dev/null || exit 1
command -v wpg >/dev/null || exit 1

# Get Colors
colors="$(sed --quiet --regexp-extended '/^\*\.((back|fore)ground|color(4|15))/p' "${HOME}/.config/wpg/formats/colors.Xresources" | \
	awk '/back/ {nbg = $NF} /fore/ {nfg = $NF} /r4/ {sbg = $NF} /r15/ {sfg = $NF} END {print nbg,nfg,sbg,sfg}')"

# Run Dmenu
dmenu_run -nb "$(cut --fields=1 --delimiter=" " <<< "${colors}")" \
	-nf "$(cut --fields=2 --delimiter=" " <<< "${colors}")" \
	-sb "$(cut --fields=3 --delimiter=" " <<< "${colors}")" \
	-sf "$(cut --fields=4 --delimiter=" " <<< "${colors}")" \
	"${@}"
