#!/usr/bin/env bash
#
# autostart.sh
#
# Autostart Applications, regardless of DE/WM

# Applications Autostart
hsetroot -solid "#000000"
nitrogen --restore
picom & disown
unclutter --jitter 50 & disown
polkit-gnome-authentication-agent-1 & disown
xautolock -time 60 -detectsleep -locker "${HOME}/scripts/tools/lockSession.sh" & disown
dunst --config "${HOME}/.config/dunst/dunstrc" & disown
kdeconnect & disown

# Tray Applications
#kdeconntect-indicator & disown
#nm-applet &
