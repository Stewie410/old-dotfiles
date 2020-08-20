#!/bin/env bash
#
# bash_aliases
#
# Handy Aliases

# ##----------------------------------------------------##
# #|		                Filesystem		            |#
# ##----------------------------------------------------##
# ls
alias l='ls'
alias ls='ls --group-directories-first --color=auto --classify'
alias la='ls --all'
alias ll='ls -l'
alias lz='ls --context'
alias lla='ls -l --almost-all'
alias llh='ls -l --human-readable'
alias llah='ls -l --almost-all --human-readable'
alias llaz='ls -l --almost-all --context'
alias llahz='ls -l --almost-all --human-readable --context'

# exa -- may replace ls eventually
alias lx='exa --color=automatic --group-directories-first --classify'
alias lxa='exa --all'
alias lxl='exa --long'
alias lxt='exa --tree'
alias lxla='exa --all --long'
alias lxta='exa --all --tree'

# dir
alias dir='dir --color=auto'

# greps
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Confirm before overwriting file
alias mv="mv --interactive"
alias cp="cp --interactive"

# Confirm before removing file
alias rm="rm --interactive"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ..3='cd ../../../'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

# ##----------------------------------------------------##
# #|		                Tools		                |#
# ##----------------------------------------------------##
# Sudo alternative
alias doas='doas --'

# Common tools
alias cprop='xprop | grep --ignore-case "class"'
alias v='vim'

# Editors
alias v='vim'
#alias em="$(command -v emacs) -nw"
#alias emacs="emacsclient -c -a 'emacs'"

# Handy Shortcuts
alias xcp='xclip -selection "clipboard"'
alias fcfv='sudo fc-cache --force --verbose'
#alias lr='sudo $(history -p \!\!)'

# "Pretty" tools
alias nf='neofetch'
#alias nfi="neofetch --w3m --source $(awk -F'=' '/^file=/{print $2}' "${HOME}/.config/nitrogen/bg-saved.cfg")"

# Oneshot Curl Utils
alias ipinfo='curl --silent --fail ipinfo.io/json'
alias pubip='curl --silent --fail icanhazip.com'

# Radios
alias btctl='bluetoothctl'
alias ubbt='sudo rfkill unblock bluetooth'
alias ubwl='sudo rfkill unblock wifi'
alias ubww='sudo rfkill unblock wwan'

# RClone
alias rclcheck='rclne check'
alias rclsync='rclone sync'
alias rclcopy='rclone copy'

# Termbin
alias tb='nc termbin.com 9999'

# Processes
alias psmem='ps auxf | sort -nfk 4'
alias pscpu='ps auxf | sort -nrk 3'
alias psmem10='ps auxf | sort -nrk 4 | head -n 10'
alias pscpu10='ps auxf | sort -nrk 3 | head -n 10'

# GPG
alias gpg-check='gpg2 --keyserver-options auto-key-retrieve --verify'
alias gpg-retrieve='gpg2 --keyserver-options auto-key-retrieve --receive-keys'

# Youtube-DL
alias ytdl='youtube-dl'
alias yta-aac='ytdl --extract-audio --audio-format aac'
alias yta-best='ytdl --extract-audio --audio-format best'
alias yta-flac='ytdl --extract-audio --audio-format flac'
alias yta-m4a='ytdl --extract-audio --audio-format m4a'
alias yta-mp3='ytdl --extract-audio --audio-format mp3'
alias yta-opus='ytdl --extract-audio --audio-format opus'
alias yta-vorb='ytdl --extract-audio --audio-format vorbis'
alias yta-wav='ytdl --extract-audio --audio-format wav'
alias ytv-best='ytdl --format bestvideo+bestaudio'

# ##----------------------------------------------------##
# #|                        SystemD                     |#
# ##----------------------------------------------------##
alias jctl='journalctl --priority=3 --catalog --boot'

# ##----------------------------------------------------##
# #|                        Session                     |#
# ##----------------------------------------------------##
alias suspend='systemctl suspend'
alias hibernate='systemctl hibernate'
alias lock_session="${HOME}/scripts/tools/lockSession.sh"
alias session_exit='i3-msg exit'

# ##----------------------------------------------------##
# #|                        Shell                       |#
# ##----------------------------------------------------##
alias tobash="sudo chsh ${USER} --shell $(command -v bash) && echo 'Log Out...'"
#alias tozsh="sudo chsh ${USER} --shell $(command -v zsh) && echo 'Log Out...'"

# ##----------------------------------------------------##
# #|		                Scripts		                |#
# ##----------------------------------------------------##
alias rst='${HOME}/scripts/tools/redshift-toggle.sh'
alias ttc='${HOME}/scripts/tools/ttc_toggle.sh --state 1'
alias gds='${HOME}/scripts/tools/gdsync-min.sh'

# ##----------------------------------------------------##
# #|		                Git		                    |#
# ##----------------------------------------------------##
# Regular git
alias git='git --no-pager'
alias gadd='git add'
alias gaddup='git add --update'
alias gbranch='git branch --all --color'
alias gcommit='git commit -m'
alias gchkout='git checkout'
alias gdiff='git diff --color'
alias ginit='git init'
alias glog='git log --pretty=oneline'
alias gstat='git status'
alias gclone='git clone'
alias gmove='git mv'
alias gpush='git push origin'
alias gpull='git pull origin'
alias gremadd='git remote add'
alias grm='git rm --cached'
alias grmf='git rm'

# Git Bare -- Dotfiles
alias gdf='git --git-dir=${HOME}/dotfiles --work-tree=$HOME'
alias gdfadd='gdf add'
alias gdfaddup='gdf add --update'
alias gdfbranch='gdf branch --all --color'
alias gdfcommit='gdf commit -m'
alias gdfchkout='gdf checkout'
alias gdfdiff='gdf diff --color'
alias gdflog='gdf log --pretty=oneline'
alias gdfstat='gdf status'
alias gdfpush='gdf push origin'
alias gdfremadd='gdf remote add'
alias gdfrm='gdf rm --cached'
alias gdfrmf='gdf rm'

# ##----------------------------------------------------##
# #|		                chmod		                |#
# ##----------------------------------------------------##
alias 000='chmod 000'
alias 600='chmod 600'
alias 644='chmod 644'
alias 700='chmod 700'
alias 750='chmod 750'
alias 755='chmod 755'

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
