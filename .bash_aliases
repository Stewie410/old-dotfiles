#!/usr/bin/env bash
#
# .bash_aliases
#
# Handy Aliases

require() {
    command -v "${*}" >/dev/null
}

# --
# -- Navigation
# --
# ls
alias l='ls'
alias ls='ls --group-directories-first --color=auto --classify'
alias la='ls --almost-all'
alias ll='ls -l'
alias lla='la -l'
alias llh='ll --human-readable'
alias llah='lla --human-readable'

# ls + SELinux
if command -v getenforce >/dev/null; then
    alias lz='ls --context'
    alias lza='ls --context --almost-all'
    alias lzah='ls --context --almost-all --human-readable'
fi

# exa -- may replace ls eventually
if command -v exa >/dev/null; then
    alias lx='exa --color=automatic --group-directories-first --classify'
    alias lxa='lx --all'
    alias lxl='lx --long'
    alias lxt='lx --tree'
    alias lxla='lx --all --long'
    alias lxta='lx --all --tree'
fi

# dir
alias dir='dir --color=auto'

# grep
alias grep='grep --color=auto'
require "egrep" || alias egrep='grep --extended-regexp'
require "fgrep" || alias fgrep='grep --fixed-strings'

# Confirm before overwriting or removing file
alias mv="mv --interactive"
alias cp="cp --interactive"
alias rm="rm --interactive"

# cd up directory tree
alias ..='cd ..'
alias ...='cd ../..'

# Zoxide
alias zq='zoxide'

# --
# -- Tools
# --
# Sudo alternative
#command -v doas >/dev/null && alias doas='doas --'

# Common tools
command -v xprop >/dev/null && alias cprop='xprop | grep --ignore-case "class"'

# Handy Shortcuts
command -v xclip >/dev/null && alias xcp='xclip -selection "clipboard"'
alias fcfv='sudo fc-cache --force --verbose'

# Oneshot Curl Utils
if command -v curl >/dev/null; then
    alias ipinfo='curl --silent --fail ipinfo.io/json'
    alias pubip='curl --silent --fail ifconfig.me; echo'
fi

# Radios
command -v bluetoothctl >/dev/null && alias btctl='bluetoothctl'
if command -v rfkill >/dev/null; then
    alias ubbt='sudo rfkill unblock bluetooth'
    alias ubwl='sudo rfkill unblock wifi'
    alias ubww='sudo rfkill unblock wwan'
fi

# RClone
if command -v rclone >/dev/null; then
    alias rclcheck='rclone check'
    alias rclsync='rclone sync'
    alias rclcopy='rclone copy'
fi

# Termbin
command -v nc >/dev/null && alias tb='nc termbin.com 9999'

# Processes
alias psmem='ps auxf | sort --numeric-sort --ignore-case --key=4'
alias pscpu='ps auxf | sort --numeric-sort --ignore-case --key=3'
alias psmem10='psmem | head --lines=10'
alias pscpu10='pscpu | head --lines=10'

# GPG
alias gpg-check='gpg2 --keyserver-options auto-key-retrieve --verify'
alias gpg-retrieve='gpg2 --keyserver-options auto-key-retrieve --receive-keys'

# Youtube-DL
if command -v youtube-dl >/dev/null; then
    alias ytdl='youtube-dl'
    #alias yta-aac='ytdl --extract-audio --audio-format aac'
    alias yta-best='ytdl --extract-audio --audio-format best'
    #alias yta-flac='ytdl --extract-audio --audio-format flac'
    #alias yta-m4a='ytdl --extract-audio --audio-format m4a'
    #alias yta-mp3='ytdl --extract-audio --audio-format mp3'
    #alias yta-opus='ytdl --extract-audio --audio-format opus'
    #alias yta-vorb='ytdl --extract-audio --audio-format vorbis'
    #alias yta-wav='ytdl --extract-audio --audio-format wav'
    alias ytv-best='ytdl --format bestvideo+bestaudio'
fi

# Bat is better than cat
command -v bat >/dev/null && alias cat='bat'

# --
# -- systemd
# --
alias jctl='journalctl --priority=3 --catalog --boot'

# --
# -- Session
# --
alias lock='XDG_SEAT_PATH="/org/freedesktop/DisplayManager/Seat0" dm-tool lock'
alias suspend='systemctl suspend'
alias hibernate='systemctl hibernate'

# --
# -- Scripts
# --
[ -s "${HOME}/scripts/tools/ttc_toggle.sh" ] && alias ttc='${HOME}/scripts/tools/ttc_toggle.sh'
[ -s "${HOME}/scripts/tools/gdsync-min.sh" ] && alias gds='${HOME}/scripts/tools/gdsync-min.sh'

# --
# -- VPNs
# --
# OpenVPN
if command -v openvpn >/dev/null; then
    [ -s "${HOME}/.OpenVPN/wtcox-udp.ovpn" ] && alias wtcox-udp='sudo openvpn --config "${HOME}/.OpenVPN/wtcox-udp.ovpn"'
fi

# --
# -- Version Control
# Git
if command -v git >/dev/null; then
    alias git='git --no-pager'
    alias gaa='git add --all'
    alias gau='git add --update'
    alias gcm='git commit -m'
    alias gd='git diff --color'
    alias gl='git log --pretty=oneline'
    alias gr='git rm --cached'
    alias grf='git rm'

    # Git Bare -- Dotfiles
    alias gdf='git --git-dir="${HOME}/dotfiles" --work-tree="${HOME}"'
    alias gdfaa='gdf add --all'
    alias gdfau='gdf add --update'
    alias gdfcm='gdf commit -m'
    alias gdfd='gdf diff --color'
    alias gdfl='gdf log --pretty=oneline'
    alias gdfr='gdf rm --cached'
    alias gdfrf='gdf rm'
fi

# ##----------------------------------------------------##
# #|		            Package Management		        |#
# ##----------------------------------------------------##
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

# paru (aur)
if command -v paru >/dev/null; then
    alias yay='paru'
    alias ain='paru --sync'
    alias arm='paru --remove'
    alias acl='paru -Rsn'
    alias asr='paru -Ss --sortby popularity'
    alias aq='paru -Q'
    alias afy='paru -Fy'
    alias afs='paru -Fs'

    # Combined
    alias sy='paru -Sy'
    alias syy='paru -Syy'
    alias syu='paru -Syu'
    alias syyu='paru -Syu'
    alias syuu='paru -Syuu'
    alias scc='paru -Scc'
fi

unset -f require
