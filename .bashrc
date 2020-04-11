#!/usr/bin/env bash
#
# .bashrc
# Author: 	Alex Paarfus <stewie410@gmail.com>
# Date: 	2020-04-11

# ##----------------------------------------------------##
# #| 		Non-Interactive Shell 			|#
# ##----------------------------------------------------##
# Return on a non-interactive shell
[[ $- == *i* ]] || return

# ##----------------------------------------------------##
# #| 		Additional Sources 			|#
# ##----------------------------------------------------##
[ -s "${HOME}/.bash_aliases" ] && source "${HOME}/.bash_aliases"
[ -s "${HOME}/.bash_functions" ] && source "${HOME}/.bash_functions"
[ -s "${HOME}/.bash_bookmarks" ] && source "${HOME}/.bash_bookmarks"

# ##----------------------------------------------------##
# #| 			Variables 			|#
# ##----------------------------------------------------##
# Define Prompts
#PS1='[\u@\h \W]\$ '
PS1='\w $ '

# Define Path
PATH="${PATH}:/opt/wine-osu/bin:$(find "${HOME}/scripts" -mindepth 1 -type d | xargs | sed 's/ /:/g')"

# Define Applications
EDITOR="$(command -v vim)"
TERMINAL="$(command -v urxvt)"
BROWSER="$(command -v firefox)"
READER="$(command -v zathura)"
FILE_MANAGER="$(command -v ranger)"
MAIL_CLIENT="$(command -v thunderbird)"
SUDO_ASKPASS="${HOME}/scripts/tools/dmenupass"

# Wine
WINEPREFIX="${HOME}/.wine_osu"
WINEARCH="win32"

# vim as man pager
#MANPAGER="$(command -v sh) -c \"col --no-backspaces | vim --not-a-term --cmd 'set ft=man ts=8 nomod nolist noma' -\""
MANPAGER="less"


# History
HISTCONTROL="ignoreboth"
HISTFILESIZE="1000000"
HISTSIZE="1000000"

# ##----------------------------------------------------##
# #| 		Less & Man Colors 			|#
# ##----------------------------------------------------##
# Enable
LESS="-R"

# Begin Bold/Blink; Reset Bold/Blink
LESS_TERMCAP_mb=$'\E[1;31m'
LESS_TERMCAP_md=$'\E[1;36m'
LESS_TERMCAP_me=$'\E[0m'

# Begin/Reset Reverse Video
LESS_TERMCAP_so=$'\E[1;44;33m'
LESS_TERMCAP_se=$'\E[0m'

# Begin/Reset Underline
LESS_TERMCAP_us=$'\E[1;32m'
LESS_TERMCAP_ue=$'\E[0m'

# ##----------------------------------------------------##
# #| 			Exports 			|#
# ##----------------------------------------------------##
export PS1
export PATH
export EDITOR TERMINAL BROWSER READER FILE_MANAGER MAIL_CLIENT SUDO_ASKPASS
export WINEPREFIX WINEARCH
export MANPAGER
export HISTCONTROL HISTFILESIZE HISTSIZE
export LESS LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me
export LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us LESS_TERMCAP_ue

# ##----------------------------------------------------##
# #| 			Bash Options 			|#
# ##----------------------------------------------------##
shopt -s checkwinsize
#shopt -s expand_aliases
shopt -s histappend
#shopt -s autocd
shopt -s cdspell
shopt -s checkjobs
#shopt -s extglob
#shopt -s globstar
#shopt -s gnu_errfmt
shopt -s mailwarn
shopt -s cmdhist

# ##----------------------------------------------------##
# #| 			Settings 			|#
# ##----------------------------------------------------##
set -o vi

