#!/usr/bin/env bash
# shellcheck disable=SC1090
#
# .bashrc
#
# Bash configuration

# Skip the remainder of configurations if shell is non-interactive
[[ $- == *i* ]] || return

# --
# -- Define environment variables
# --
# Specify shell prompt
#export PS1='[\u@\h \W]\$ '
#export PS1='\w $ '
command -v starship >/dev/null && eval "$(starship init bash)"

# Add osu-win to PATH
PATH="${PATH}:/opt/wine-osu/bin"

# Add scripts to PATH
PATH="${PATH}:$(find "${HOME}/scripts" -mindepth 1 -maxdepth 1 -type d | paste --serial --delimiter=":")"
export PATH

# Define default/preferred applications
EDITOR="vim"
TERMINAL="alacritty"
BROWSER="firefox"
READER="zathura"
FILE_MANAGER="ranger"
MAIL_CLIENT="thunderbird"
SUDO_ASKPASS="${HOME}/scripts/tools/dmenupass"
export EDITOR TERMINAL BROWSER READER FILE_MANAGER MAIL_CLIENT SUDO_ASKPASS

# Wine
WINEPREFIX="${HOME}/.wine_osu"
WINEARCH="win32"
export WINEPREFIX WINEARCH

# XDG
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME

# History
HISTCONTROL="ignoreboth"
HISTFILESIZE="1000000"
HISTSIZE="1000000"
export HISTCONTROL HISTFILESIZE HISTSIZE

# Specify command string to use when viewing manpages
if command -v bat >/dev/null; then
    MANPAGER="sh -c 'col --no-backspaces --spaces | bat --language man --plain'"
else
    MANPAGER="less"
fi
export MANPAGER

# Enable color support in less
LESS="--RAW-CONTROL-CHARS"
LESS_TERMCAP_mb=$'\E[1;31m'
LESS_TERMCAP_md=$'\E[1;36m'
LESS_TERMCAP_me=$'\E[0m'
LESS_TERMCAP_so=$'\E[1;44;33m'
LESS_TERMCAP_se=$'\E[0m'
LESS_TERMCAP_us=$'\E[1;32m'
LESS_TERMCAP_ue=$'\E[0m'
export LESS LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us LESS_TERMCAP_ue

# QT Platform
QT_QPA_PLATFORMTHEME="qt5ct"
export QT_QPA_PLATFORMTHEME

# QT Scaling factor
QT_AUTO_SCREEN_SCALE_FACTOR="0"
export QT_AUTO_SCREEN_SCALE_FACTOR

# GTK2 Configuration Files
GTK2_RC_FILES="${HOME}/.gtkrc-2.0"
export GTK2_RC_FILES

# Specify that the current window-manager does not support re-parenting
_JAVA_JWT_WM_NONREPARENTING="1"
export _JAVA_JWT_WM_NONREPARENTING

# --
# -- Shell Options
# --
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

# --
# -- Additional Configuration
# --
for i in "aliases" "functions" "bookmarks" "completion"; do
    [ -s "${HOME}/.bash_${i}" ] && source "${HOME}/.bash_${i}"
done
