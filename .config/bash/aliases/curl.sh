#!/usr/bin/env bash

alias wttr='curl --silent --fail wttr.in'
alias ipinfo='curl --silent --fail ipinfo.io/json'

if command -v jq &>/dev/null; then
	alias pubip="ipinfo | jq '.ip' | tr -d '\"'"
else
	alias pubip='icanhazip.com'
fi
