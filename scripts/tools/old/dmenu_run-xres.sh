#!/bin/bash
#
# dmenu_run-xres.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-01-21
#
# A themed wrapper for dmenu_run

# Functions
getPolybarColors() {
	# Get our Polybar theme colors from config
	srcf="$HOME/.config/polybar/config"
	xres="$HOME/.config/wpg/formats/colors.Xresources"
	nb="$(grep "background =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/g;1q')"
	nf="$(grep "foreground =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/g;1q')"
	sb="$(grep "primary =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/g;1q')"
	sf="$(grep "foreground-alt =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/g;1q')"

	# Then get actual values from xres && apply to vars below
	if [ ! -f "$xres" ]; then xres="$HOME/.Xresources"; fi
	nbg="$(grep -E "^\*\.$nb" "$xres" | awk '{print $2}' | sed -r 'y/abcdef/ABCDEF/;s/#//')"
	nfg="$(grep -E "^\*\.$nf" "$xres" | awk '{print $2}' | sed -r 'y/abcdef/ABCDEF/;s/#//')"
	sbg="$(grep -E "^\*\.$sb" "$xres" | awk '{print $2}' | sed -r 'y/abcdef/ABCDEF/;s/#//')"
	sfg="$(grep -E "^\*\.$sf" "$xres" | awk '{print $2}' | sed -r 'y/abcdef/ABCDEF/;s/#//')"
}

# Vars
nbg=""				# Normal Background
nfg=""				# Normal Foreground
sbg=""				# Selected Background
sfg=""				# Selected Foreground
fnt="Monospace-10"		# Font

# Get colors
getPolybarColors

# Run dmenu_run
dmenu_run -nb "#$nbg" -nf "#$nfg" -sb "#$sbg" -sf "#$sfg" -fn "$fnt" "$@"

# Clear memory
unset nbg nfg sbg sfg fnt
