#!/usr/bin/env bash
#
# Wrapper for scrot to auto-name output

out="${HOME}/Pictures/Screenshots/$(date --iso-8601)/$(date --iso-8601="seconds").png"
trap 'unset out' EXIT
mkdir --parents "${out%/*}"
scrot "${@}" -- "${out}"
