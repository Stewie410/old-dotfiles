#!/usr/bin/env bash
#
# autostart.sh
#
# Autostart Applications, regardless of DE/WM

hsetroot -solid "#000000"
nitrogen --restore
picom &
unclutter --jitter 50 &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
xautolock -time 60 -detectsleep -locker "${HOME}/scripts/tools/lockSession.sh"
dunst
#kdeconnect && kdeconntect-indicator
