#!/bin/env bash
#
# xinitrc
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2020-04-12
#
# Executed by startx (run your window manager from here)

# ##----------------------------------------------------##
# #|		        Load X11 Sources		            |#
# ##----------------------------------------------------##
# Load Xresources
xinitd="/etc/X11/xinit"
[ -s "${xinitd}/.Xresources" ] && xrdb -merge "${xinitd}/.Xresources"
[ -s "${HOME}/.Xresources" ] && xrdb -merge "${HOME}/.Xresources"

# Load Modmap
[ -s "${xinitd}/.Xmodmap" ] && xmodmap "${xinitd}/.Xmodmap"
[ -s "${HOME}/.Xmodmap" ] && xmodmap "${HOME}/.Xmodmap"
unset xinitd

# ##----------------------------------------------------##
# #|		            X11 Autostart		            |#
# ##----------------------------------------------------##
xinitrcd="/etc/X11/xinit/xnitrc.d"
[ -d "${xinitrcd}" ] && find "${xinitrcd}" -type f -name "*.sh" -print0 | xargs --null -I {} source "{}"
unset xinitrcd

# ##----------------------------------------------------##
# #|		            X11 Session		                |#
# ##----------------------------------------------------##
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
	dbus-launch "${dbus_args[*]}"
}

#exec "$(get_session)"
get_session

# ##----------------------------------------------------##
# #| 			        Auto Start 			            |#
# ##----------------------------------------------------##
#if ! [[ "${SESSION,,}" =~ xfce ]]; then 
#    # Set Wallpaper & Theme
#    #~/.fehbg &
#    #~/.config/wpg/wp_init.sh
#    hsetroot -solid "#000000" &
#    nitrogen --restore &
#    "${HOME}/scripts/compton-launch.sh" &
#    "${HOME}/scripts/polybar/launchpb.sh" &
#    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" &
#    unclutter --jitter 50 &
#    xautolock -time 60 -detectsleep -locker "${HOME}/scripts/tools/lockSession.sh" &
#    dunst &
#fi
#
## KDE Connect
#kdeconnectd &
#kdeconnect-indicator &
