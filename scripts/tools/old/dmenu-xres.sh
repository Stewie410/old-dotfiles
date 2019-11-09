#!/bin/bash
#
# dmenu-xres.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-01-21
#
# A themed wrapper for dmenu 

# Functions
getPolybarColors() {
	# Get our Polybar theme colors from config
	srcf="$HOME/.config/polybar/config"
	xres="$HOME/.config/wpg/formats/colors.Xresources"
	_nb="$(grep "background =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/g;1q')"
	_nf="$(grep "foreground =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/g;1q')"
	_sb="$(grep "primary =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/g;1q')"
	_sf="$(grep "foreground-alt =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/g;1q')"

	# Then get actual values from xres && apply to vars below
	if [ ! -f "$xres" ]; then xres="$HOME/.Xresources"; fi
	nbg="$(grep -E "^\*\.$_nb" "$xres" | awk '{print $2}')"
	nfg="$(grep -E "^\*\.$_nf" "$xres" | awk '{print $2}')"
	sbg="$(grep -E "^\*\.$_sb" "$xres" | awk '{print $2}')"
	sfg="$(grep -E "^\*\.$_sf" "$xres" | awk '{print $2}')"

	# Clear memory
	unset srcf _nb _nf _sb _sf
}

# Vars
nbg=""				# Normal Background
nfg=""				# Normal Foreground
sbg=""				# Selected Background
sfg=""				# Selected Foreground
fnt="Monospace-10"		# Font

# Get colors
getPolybarColors

# Do the dmenu thing
dmenu -nb "$nbg" -nf "$nfg" -sb "$sbg" -sf "$sfg" -fn "$fnt" "$@"

unset nbg nfg sbg sfg fnt
