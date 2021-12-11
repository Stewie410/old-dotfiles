#!/usr/bin/env bash

# Fat Finger
alias :q='exit'
alias kk='ls -l'
alias chmox='chmod +x'

# Path Overrides
#alias nslookup="/mnt/c/Windows/System32/nslookup"

# ls
alias l='ls'
alias ls='ls --group-directories-first --color=auto --classify'
alias la='ls --almost-all'
alias ll='ls -l'
alias lla='ls --almost-all -l'
alias llh='ls -l --human-readable'
alias llah='ls --almost-all --human-readable -l'
if command -v getenforce &>/dev/null; then
    alias lZ='ls --context'
    alias lZa='lZ --almost-all'
    alias lZah='lZa --human-readable'
fi

# exa
if command -v exa &>/dev/null; then
    alias lx='exa --color=automatic --group-directories-first --classify'
    alias lxa='lx --all'
    alias lxl='lx --long'
    alias lxt='lx --tree'
    alias lxla='lxa --long'
    alias lxta='lxt --all'
fi

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
if command -v zoxide &>/dev/null; then
    alias z='zoxide'
    alias z..='zoxide ..'
    alias z...='zoxide ../..'
fi

# Use 'command -v' instead of 'which'
alias which='command -v'

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Require Interaction
alias mv='mv --interactive'
alias cp='cp --interactive'
alias rm='rm --interactive'

# Permissions
alias 000='chmod 000'
alias 600='chmod 600'
alias 644='chmod 644'
alias 700='chmod 700'
alias 750='chmod 750'
alias 755='chmod 755'

# File Management
alias dir='dir --color-auto'
alias vdir='vdir --color-auto'
alias explorer='explorer.exe'

# doas
if command -v doas &>/dev/null; then
    alias doas='doas --'
    alias sudo='doas'
fi

# Tools
alias ric='rc -f ansi'
alias shellcheck='shellcheck --color=always'
alias bat='batcat'
#alias cat='bat'

# Caffeine
caf="/mnt/c/ProgramData/chocolatey/bin/caffeine32.exe"
if [ -s "${caf}" ]; then
    [ -s "${caf/32/64}" ] && caf="${caf/32/64}"
    alias caffeine="${caf}"
    alias caffeine-toggle="${caf} -apptoggle"
    alias caffeine-kill="${caf} -appexit"
    alias caffeine-start="${caf} -allowss -stes -onac"
fi
unset caf

# urlscan.io
if command -v urlscanio &>/dev/null; then
    alias us='urlscanio'
    alias usi='us --investigate'
    alias uss='us --submit'
    alias usr='us --retrieve'
fi

# Windows Clip
alias clip='clip.exe'

# Editors
alias v='vim'
alias vim-vanilla='vim -u NONE'
command -v nvim &>/dev/null && alias nv='nvim'
command -v code-insiders &>/dev/null && alias code='code-insiders'

# LaTeX
alias xelatexmk='latexmk -xelatex'

# cURL Utilities
alias wttr='curl --silent --fail wttr.in'
alias ipinfo='curl --silent --fail ipinfo.io/json'
alias pubip="ipinfo | jq '.ip' | tr -d '\"'"

# termbin
alias tb='nc termbin.com 9999'

# Process Management
alias psmem='ps auxf | sort --numeric-sort --ignore-case --key=4'
alias pscpu='ps auxf | sort --numeric-sort --ignore-case --key=3'
alias psmem10='psmem | head --lines=10'
alias pscpu10='pscpu | head --lines=10'

# youtube-dl
if command -v youtube-dl &>/dev/null; then
    alias ytdl='youtube-dl'
    alias yta-best='ytdl --extract-audio --audio-format best'
    alias ytv-best='ytdl --format bestvideo+bestaudio'
fi

# journalctl
alias jctl='journalctl --priority=3 --catalog --boot'

# session management
alias lock='XDG_SEAT_PATH="/org/freedesktop/DisplayManager/Seat0" dm-tool lock'
alias suspend='systemctl suspend'
alias hibernate='systemctl hibernate'

# Git
alias git='git --no-pager'
alias grm='git rm --cached'
alias grmf='git rm'

# Git Bare -> Dotfiles
alias gdf='git --git-dir="${HOME}/dotfiles" --work-tree="${HOME}"'
alias gdfrm='gdf rm --cached'
alias gdfrmf='gdf rm'

# Subversion
[ -s "/mnt/c/Program Files/TortoiseSVN/bin/svn.exe" ] && alias svn='/mnt/c/Program\ Files/TortoiseSVN/bin/svn.exe'
if command -v svn &>/dev/null; then
    alias svn='/mnt/c/Program\ Files/TortoiseSVN/bin/svn.exe'
    alias svaa='svn add --force --parents'
    alias svcl='svn changelist'
    alias svcm='svn commit'
    alias svco='svn checkout'
    alias svcp='svn copy'
    alias svcu='svn cleanup'
    alias svdiff='svn diff'
    alias svls='svn list'
    alias svrm='svn delete --keep-local'
    alias svrmf='svn delete'
    alias svmg='svn merge'
    alias svmi='svn mergeinfo'
    alias svrv='svn revert'
    alias svst='svn status'
    alias svud='svn update'
    alias svug='svn upgrade'
    alias svxp='svn export'
fi

# git clone
alias gcgh='${HOME}/scripts/tools/gitclone.sh -g'
alias gcgl='${HOME}/scripts/tools/gitclone.sh -l'
alias gcsl='${HOME}/scripts/tools/gitclone.sh -s'

# sshman
alias sshman='${WINHOME}/Documents/Programming/Bash/sshman/sshman.sh'
