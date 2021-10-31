#!/usr/bin/env bash
# shellcheck disable=SC2155,SC1091
#
# Bash configuration

# Enable X11 forwarding
export DISPLAY="$(${HOME}/scripts/tools/wsl/initWSLX11ForwardingWFWRule.sh)"
export LIBGL_ALWAYS_INDIRECT="1"

# Allow VPN + WSL Support
wsl.exe -d wsl-vpnkit service wsl-vpnkit start

# Skip configuration if not running interactively
[[ "${-}" =~ i ]] || return

# Shell Prompt
#export PS1='[\u@\h \W]\$ '
#export PS1='\w $ '
command -v starship >/dev/null && eval "$(starship init bash)"

# Update PATH
export PATH="${PATH}:$(find "${HOME}/scripts" -mindepth 1 -maxdepth 1 -type d | paste --serial --delimiter=":")"
export PATH="${PATH}:${HOME}/.local/bin"

# Define editor
export EDITOR="vim"

# Define terminal
#export TERMINAL="alacritty"

# Define web browser
#export BROWSER="firefox"

# Define document reader
#export READER="zathura"

# Define file manager
#export FILE_MANAGER="ranger"

# Define email client
#export MAIL_CLIENT="thunderbird"

# Define the sudo-compliant of dmenu
#export SUDO_ASKPASS="${HOME}/scripts/tools/dmenupass"

# Wine
#export WINEPREFIX="${HOME}/.wine_osu"
#export WINEARCH="win32"

# XDG
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# BASH History
export HISTCONTROL="ignoreboth"
export HISTFILESIZE="1000000"
export HISTSIZE="1000000"

# Use bat as manpager if available
#command -v bat &>/dev/null && export MANPAGER="sh -c 'col --no-backspaces --spaces | bat --language man --plain'"
command -v bat &>/dev/null && export MANPAGER="sh -c 'col -bx | bat --language man --plain'"

# Enable color support in less
export LESS="--RAW-CONTROL-CHARS"
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[1;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# QT Options
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR="0"

# GTK Options
export GTK2_RC_FILES="${HOME}/.gtkrc-2.0"

# Fix java breaking on window managers
export _JAVA_JWT_WM_NONREPARENTING="1"

# Save multi-line commands to history as a single line (if possible)
shopt -s cmdhist

# Attempt to resolve spelling errors in directory names
shopt -s dirspell

# Allow the '**' glob to specify a recursive search
shopt -s globstar

# Append command history file, instead of overwriting it
shopt -s histappend

# Display a warning message at exit if still checking for mail
shopt -s mailwarn

# Don't attempt completion if nothing is specified
shopt -s no_empty_cmd_completion

# Use vi-mode instead of emacs-mode
set -o vi

# Import additional configurations
[ -s "${HOME}/.bash_aliases" ] && source "${HOME}/.bash_aliases"
[ -s "${HOME}/.bash_aliases_private" ] && source "${HOME}/.bash_aliases_private"
[ -s "${HOME}/.bash_functions" ] && source "${HOME}/.bash_functions"
#[ -s "${HOME}/.bash_bookmarks" ] && source "${HOME}/.bash_bookmarks"
#[ -s "${HOME}/.bash_completion" ] && source "${HOME}/.bash_completion"
