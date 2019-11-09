#!/bin/bash
#
# dmenu_sudo-xres.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-01-22
#
# A themed wrapper for dmenu, to grab the sudo password

# Functions
getPolybarColors() {
	# Get our Polybar theme colors from config
	srcf="$HOME/.config/polybar/config"
	xres="$HOME/.config/wpg/formats/colors.Xresources"
	_nb="$(grep "background =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/;1q')"
	_sb="$(grep "primary =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/;1q')"
	_sf="$(grep "foreground-alt =" "$srcf" | sed -r 's/^.*(color[0-9]{1,2}).*$/\1/;1q')"

	# Then get actual values from xres && apply to vars below
	if [ ! -f "$xres" ]; then xres="$HOME/.Xresources"; fi
	nbg="$(grep -E "^\*\.$_nb" "$xres" | awk '{print $2}')"
	sbg="$(grep -E "^\*\.$_sb" "$xres" | awk '{print $2}')"
	sfg="$(grep -E "^\*\.$_sf" "$xres" | awk '{print $2}')"

	# Clear memory
	unset srcf _nb _nf _sb _sf
}

# Vars
nbg=""				# Normal Background
sbg=""				# Selected Background
sfg=""				# Selected Foreground
fnt="Monospace-10"		# Font
prompt="Password:"		# Prompt

# Get colors
getPolybarColors

# Do the dmenu thing
dmenu -nb "$nbg" -nf "$nbg" -sb "$sbg" -sf "$sfg" -fn "$fnt" -p "$prompt" "$@" <&- && echo

unset nbg nfg sbg sfg fnt
