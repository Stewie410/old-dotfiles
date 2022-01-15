#!/usr/bin/env bash

alias grep='grep --color=auto'

if command -v egrep &>/dev/null; then
	alias egrep='egrep --color=auto'
else
	alias egrep='grep --extended-regexp --color=auto'
fi

if command -v fgrep &>/dev/null; then
	alias fgrep='fgrep --color=auto'
else
	alias fgrep='grep --fixed-strings --color=auto'
fi
