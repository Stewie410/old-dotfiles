#!/usr/bin/env bash
#
# dwm-start.sh
#
# Start dwm & other applications

# Application Autostart
hsetroot -solid "#000000"
nitrogen --restore >/dev/null 2>&1
picom &>/dev/null & disown
unclutter --jitter 50 &>/dev/null & disown
polkit-gnome-authentication-agent-1 &>/dev/null & disown
xautolock -time 60 -detectsleep \
    -locker "${HOME}/scripts/tools/lockSession.sh" &>/dev/null & disown
dunst --config "${HOME}/.config/dunst/dunstrc" &>/dev/null & disown
kdeconnect &>/dev/null & disown

# Tray Applications
nm-applet &>/dev/null & disown
#kdeconntect-indicator &>/dev/null & disown

# Start DWM
exec /usr/local/bin/dwm >/dev/null
