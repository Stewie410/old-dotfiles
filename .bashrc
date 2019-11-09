#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PS1='[\u@\h \W]\$ '

# Aliases, Functions and Bookmarks
if [ -s "${HOME}/.bash_aliases" ]; then source "${HOME}/.bash_aliases"; fi
if [ -s "${HOME}/.bash_functions" ]; then source "${HOME}/.bash_functions"; fi
if [ -s "${HOME}/.bash_bookmarks" ]; then source "${HOME}/.bash_bookmarks"; fi

# Environment Variables
export PATH="${PATH}:/opt/wine-osu/bin:$(du "${HOME}/scripts" | cut --fields=2 | tr '\n' ':')"
export EDITOR="vim"
export TERMINAL="urxvt"
export BROWSER="firefox"
export READER="zathura"
export FILE="ranger"
export MAILCLIENT="thunderbird"

export SUDO_ASKPASS="${HOME}/.scripts/tools/dmenupass"
export WINEPREFIX="${HOME}/.wine_osu"
export WINEARCH=win32

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'		# begin bold
export LESS_TERMCAP_md=$'\E[1;36m'		# begin blink
export LESS_TERMCAP_me=$'\E[0m'			# reset bold/blink
export LESS_TERMCAP_so=$'\E[1;44;33m'		# begin reverse video
export LESS_TERMCAP_se=$'\E[0m'			# reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'		# begin underline
export LESS_TERMCAP_ue=$'\E[0m'			# reset underline
