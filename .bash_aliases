#!/bin/env bash
#
# bash_aliases
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-09
#
# 

# ##------------------------------------##
# #|		Filesystem		|#
# ##------------------------------------##
# ls
alias l='ls'
alias ls='ls --group-directories-first --color=auto'
alias la='ls --all'
alias ll='ls -l'
alias lz='ls --context'
alias lla='ls -l --all'
alias llh='ls -l --human-readable'
alias llah='ls -l --all --human-readable'
alias llaz='ls -l --all --context'
alias llahz='ls -l --all --human-readable --context'

# dir
alias dir='dir --color=auto'

# grep
alias grep='grep --color=auto'

# ##----------------------------##
# #|		Tools		|#
# ##----------------------------##
# Common tools
alias cprop='xprop | grep --ignore-case "class"'

# Handy Shortcuts
alias xcp='xclip -selection "clipboard"'
alias fcfv='sudo fc-cache --force --verbose'
alias lr='sudo $(history -p \!\!)'

# "Pretty" tools
alias nf='clear && neofetch'
alias nfi='neofetch --w3m --source $(cat ${HOME}/.cache/wal/wal)'

# Oneshot Curl Utils
alias ipinfo='curl --silent --fail ipinfo.io/json'
alias pubip='curl --silent --fail icanhazip.com'

# Radios
alias btctl='bluetoothctl'
alias ubbt='sudo rfkill unblock bluetooth'
alias ubwl='sudo rfkill unblock wifi'
alias ubww='sudo rfkill unblock wwan'

# Cloud-Utilties
alias rcl='rclone'
alias rclgchck='rclone check GDrive: ${HOME}/GDrive/'
alias rclgpull='rclone sync GDrive: ${HOME}/GDrive/'
alias rclgpush='rclone sync ${HOME}/GDrive/ GDrive:'

# ##----------------------------##
# #|		Scripts		|#
# ##----------------------------##
alias rst='${HOME}/scripts/tools/redshift-toggle.sh'
alias ttc='${HOME}/scripts/tools/ttc_toggle.sh --state 1'
alias gds='${HOME}/scripts/cron/gdsync.sh'

# ##----------------------------##
# #|		Git		|#
# ##----------------------------##
alias git='git --no-pager'
alias ga='git add'
alias gb='git branch --all --color'
alias gc='git commit'
alias gd='git diff --color'
alias gi='git init'
alias gl='git log --pretty=oneline'
alias gs='git status'
alias gcl='git clone'
alias gco='git checkout'
alias gmv='git mv'
alias gps='git push'
alias grm='git rm'

# ##------------------------------------##
# #|		Git Bare		|#
# ##------------------------------------##
alias gdf='git --git-dir=${HOME}/dotfiles --work-tree=$HOME'

# ##----------------------------##
# #|		chmod		|#
# ##----------------------------##
alias 000='chmod 000'
alias 600='chmod 600'
alias 644='chmod 644'
alias 700='chmod 700'
alias 750='chmod 750'
alias 755='chmod 755'

# ##--------------------------------------------##
# #|		Package Management		|#
# ##--------------------------------------------##
# pacman
alias pacman='sudo pacman'
alias psyu='pacman -Syu'
alias psyyu='pacman -Syyu'
alias psy='pacman -Sy'
alias psyy='pacman -Syy'
alias pin='pacman -S'
alias prm='pacman -R'
alias pcl='pacman -Rsn'
alias psr='pacman -Ss'
alias pq='pacman --query'
alias pfy='pacman -Fy'
alias pfs='pacman -F'

# yay (aur)
alias ain='yay --sync'
alias arm='yay --remove'
alias acl='yay -Rsn'
alias asr='yay -Ss --sortby popularity'
alias aq='yay -Q'
alias afy='yay -Fy'
alias afs='yay -Fs'

# Combined
alias sy='yay -Sy'
alias syy='yay -Syy'
alias syu='yay -Syu'
alias syyu='yay -Syu'
alias scc='yay -Scc'
