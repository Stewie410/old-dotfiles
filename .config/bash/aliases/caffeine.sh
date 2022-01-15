#!/usr/bin/env bash
# shellcheck disable=SC2139

caf="/mnt/c/ProgramData/chocolatey/bin/caffeine32.exe"
if [ -s "${caf}" ]; then
	[ -s "${caf/32/64}" ] && caf="${caf/32/64}"
	alias caffeine="${caf}"
	alias caffeine-toggle="${caf} -apptoggle"
	alias caffeine-kill="${caf} -appexit"
	alias caffeine-start="${caf} -allowss -stes -onac"
fi
unset caf
