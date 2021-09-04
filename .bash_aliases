#!/usr/bin/env bash
#
# .bash_aliases
#
# Handy Aliases

# ls
alias l='ls'
alias ls='ls --group-directories-first --color=auto --classify'
alias la='ls --almost-all' \
    ll='ls -l'
alias lla='la -l' \
    llh='ll --human-readable'
alias llah='lla --human-readable'

# ls -> SELinux
if command -v getenforce &>/dev/null; then
    alias lz='ls --context'
    alias lza='lz --almost-all'
    alias lzah='lza --human-readable'
fi

# exa
alias lx='exa --color=automatic --group-directories-first --classify'
alias lxa='lx --all' \
    lxl='lx --long' \
    lxt='lx --tree'
alias lxla='lxa --long' \
    lxta='lxt --all'

# dir
alias dir='dir --color=auto'

# grep
alias grep='grep --color=auto'
command -v egrep &>/dev/null || alias egrep='grep --extended-regexp'
command -v fgrep &>/dev/null || alias fgrep='grep --fixed-strings'

# confirm before you break something
alias mv='mv --interactive' \
    cp='cp --interactive' \
    rm='rm --interactive'

# cd up directory tree
alias ..='cd ..' \
    ...='cd ../..'

# Zoxide
alias zq='zoxide'

# doas
#command -v doas >/dev/null && alias doas='doas --'

# xprop
alias cprop='xprop | grep --ignore-case class'

# xclip
alias xcp='xclip -selection clipboard'

# fc-cache
alias fcfv='sudo fc-cache --force --verbose'

# public ip
alias pubip='curl --silent --fail ifconfig.me'
alias ipinfo='curl --silent --fail ipinfo.io/json'

# radio control
alias btctl='bluetoothctl'
alias ubbt='sudo rfkill unblock bluetooth'
alias ubwl='sudo rfkill unblock wifi'
alias ubww='sudo rfkill unblock wwan'

# rclone
alias rclcheck='rclone check'
alias rclsync='rclone sync'
alias rclcopy='rclone copy'

# termin
alias tb='nc termbin.com 9999'

# ps
alias psmem='ps auxf | sort --numeric-sort --ignore-case --key=4'
alias pscpu='ps auxf | sort --numeric-sort --ignore-case --key=3'

# gpg
alias gpg-check='gpg2 --keyserver-options auto-key-retrieve --verify'
alias gpg-retrieve='gpg2 --keyserver-options auto-key-retrieve --receive-keys'

# youtube-dl
alias ytdl='youtube-dl'
alias yta-best='ytdl --extract-audio --audio-format best'
alias ytv-best='ytdl --format bestvideo+bestaudio'

# bat
alias cat='bat'

# journalctl
alias jctl='journalctl --priority=3 --catalog --boot'

# session management
alias lock='XDG_SEAT_PATH="/org/freedesktop/DisplayManager/Seat0" dm-tool lock'
alias suspend='systemctl suspend'
alias hibernate='systemctl hibernate'

# git
alias git='git --no-pager'
alias grm='git rm --cached'
alias grmf='git rm'

# git -> dotfiles bare repo
alias gdf='git --git-dir="${HOME}/dotfiles" --work-tree="${HOME}"'
alias gdfrm='gdf rm --cached'
alias gdfrmf='gdf rm'

# pacman
alias pacman='sudo pacman'

# aura
alias aura='sudo aura'

# toggle tap-to-click
alias ttc='${HOME}/scripts/tools/ttc_toggle.sh'

# google-drive sync
alias gds='${HOME}/scripts/tools/gdsync-min.sh'

# git clone
alias gcgh='${HOME}/scripts/tools/gitclone.sh -g'
alias gcgl='${HOME}/scripts/tools/gitclone.sh -l'
alias gcsl='${HOME}/scripts/tools/gitclone.sh -s'
