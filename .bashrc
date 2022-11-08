#!/usr/bin/env bash
# shellcheck source=/dev/null

# Skip customizations if not running interactively
[[ "${-}" != *i* ]] && return

# Shell options
set -o vi
stty -ixon
shopt -s histappend cdspell checkwinsize checkjobs cmdhist globstar mailwarn no_empty_cmd_completion

# Manpage Pager
command -v batcat &>/dev/null && export MANPAGER="sh -c 'col -bx | batcat --language man --plain'"

# Make LESS more friendly for non-text input files
[[ -x "/usr/bin/lesspipe" ]] && eval "$(SHELL="/bin/sh" lesspipe)"

# Starship Prompt
eval "$(starship init bash)"

# Load SSH Key(s) into Keychain
eval "$(keychain --eval --agents ssh \
	"${HOME}/.ssh/${HOSTNAME}/id_rsa" \
	"${HOME}/.ssh/${HOSTNAME}/github/id_rsa" \
	"${HOME}/.ssh/${HOSTNAME}/gitlab/id_rsa" \
)"

# Start wsl-vpnkit for DNS & Networking support with VPNs...
# https://github.com/sakai135/wsl-vpnkit
wsl.exe -d wsl-vpnkit service wsl-vpnkit start

# PATH
PATH+=":${HOME}/.cargo/bin"
PATH+=":${HOME}/.local/bin"
export PATH

# History
HISTSIZE=""
HISTFILESIZE=""
HISTCONTROL="ignoreboth"
HISTIGNORE=$'[\t]*:&:[fb]g:exit'
export HISTSIZE HISTFILESIZE HISTCONTROL HISTIGNORE

# Environment
EDITOR="$(command -v vim)"
FILE_MANAGER="$(command -v explorer.exe)"
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export EDITOR FILE_MANAGER JAVA_HOME

# LESS colors
LESS="-R"
LESS_TERMCAP_mb=$'\E[1;31m'
LESS_TERMCAP_md=$'\E[1;36m'
LESS_TERMCAP_me=$'\E[0m'
LESS_TERMCAP_so=$'\E[1;44;33m'
LESS_TERMCAP_se=$'\E[0m'
LESS_TERMCAP_us=$'\E[1;32m'
LESS_TERMCAP_ue=$'\E[0m'
export LESS LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us LESS_TERMCAP_ue

# XDG
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME

# urlscanio
[[ -n "${URLSCAN_DATA_DIR}" && ! -d "${URLSCAN_DATA_DIR}" ]] && mkdir --parents "${URLSCAN_DATA_DIR}"

# Include published configurations
[[ -s "${HOME}/.bash_aliases" ]] && source "${HOME}/.bash_aliases"
[[ -s "${HOME}/.bash_functions" ]] && source "${HOME}/.bash_functions"

# Include private configurations
[[ -s "${XDG_CONFIG_HOME}/bash/private/aliases" ]] && source "${XDG_CONFIG_HOME}/bash/private/aliases"
[[ -s "${XDG_CONFIG_HOME}/bash/private/functions" ]] && source "${XDG_CONFIG_HOME}/bash/private/functions"

# Generated for envman.  Do not edit
[ -s "${HOME}/.config/envman/load.sh" ] && source "${HOME}/.config/envman/load.sh"

true
