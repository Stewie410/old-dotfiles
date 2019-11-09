#!/bin/env bash
#
# xinitrc
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-09
#
# Executed by startx (run your window manager from here)

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
_resource_usr="${HOME}/.Xresources"
_resource_sys="/etc/X11/xinit/.Xresources"
_modmap_usr="${HOME}/.Xmodmap"
_modmap_sys="/etc/X11/xinit/.Xmodmap"
SESSION=${1:-xfce}

# merge in defaults and keymaps
# ##--------------------------------------------##
# #|		Load X11 Sources		|#
# ##--------------------------------------------##
# Load Defaults
if [ -s "${_resource_sys}" ]; then xrdb -merge "${_resource_sys}"; fi
if [ -s "${_modmap_sys}" ]; then xmodmap "${_modmap_sys}"; fi

# Load User Configurations
if [ -s "${_resource_usr}" ]; then xrdb -merge "${_resource_usr}"; fi
if [ -s "${_modmap_usr}" ]; then xmodmap "${_modmap_usr}"; fi

# ##------------------------------------##
# #|		X11 Autostart		|#
# ##------------------------------------##
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# ##------------------------------------##
# #|		X11 Session		|#
# ##------------------------------------##
get_session(){
	local dbus_args=(--sh-syntax --exit-with-session)
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

	echo "dbus-launch ${dbus_args[*]}"
}

exec $(get_session)
