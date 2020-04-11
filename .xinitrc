#!/bin/env bash
#
# xinitrc
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-11
#
# Executed by startx (run your window manager from here)

# ##--------------------------------------------##
# #|		Load X11 Sources		|#
# ##--------------------------------------------##
# Load Xresources
[ -s "/etc/X11/xinit/.Xresources" ] && xrdb -merge "/etc/X11/xinit/.Xresources"
[ -s "${HOME}/.Xresources" ] && xrdb -merge "${HOME}/.Xresources"

# Load Modmap
[ -s "/etc/X11/xinit/.Xmodmap" ] && xmodmap "/etc/X11/xinit/.Xmodmap"
[ -s "${HOME}/.Xmodmap" ] && xmodmap "${HOME}/.Xmodmap"

# ##------------------------------------##
# #|		X11 Autostart		|#
# ##------------------------------------##
[ -d "/etc/X11/xinit/xinitrc.d" ] && \
	find "/etc/X11/xinit/xinitrc.d" -type f -name "*.sh" | xargs -I {} soruce "{}"

# ##------------------------------------##
# #|		X11 Session		|#
# ##------------------------------------##
SESSION=${1:-xfce}
get_session(){
	local dbus_args
	dbus_args=(--sh-syntax --exit-with-session)

	# Get Session Type
	case "$SESSION" in
		awesome) dbus_args+=(awesome) ;;
		bspwm) dbus_args+=(bspwm-session) ;;
		budgie) dbus_args+=(budgie-desktop) ;;
		cinnamon) dbus_args+=(cinnamon-session) ;;
		deepin) dbus_args+=(startdde) ;;
		enlightenment) dbus_args+=(enlightenment_start) ;;
		fluxbox) dbus_args+=(startfluxbox) ;;
		gnome) dbus_args+=(gnome-session) ;;
		i3|i3wm) dbus_args+=(i3 --shmlog-size 0) ;;
		jwm) dbus_args+=(jwm) ;;
		kde) dbus_args+=(startkde) ;;
		lxde) dbus_args+=(startlxde) ;;
		lxqt) dbus_args+=(lxqt-session) ;;
		mate) dbus_args+=(mate-session) ;;
		xfce) dbus_args+=(xfce4-session) ;;
		openbox) dbus_args+=(openbox-session) ;;
		*) dbus_args+=("$SESSION") ;;
	esac

	# Return Session
	echo "dbus-launch ${dbus_args[*]}"
}

exec "$(get_session)"

# ##----------------------------------------------------##
# #| 			Auto Start 			|#
# ##----------------------------------------------------##
