#!/bin/env bash
# shellcheck disable=SC1090

dir="${XDG_CONFIG_HOME:-${HOME}/.config}/bash/functions"
if [ -d "${dir}" ]; then
	source "${dir}/bm.sh"
	source "${dir}/cheat.sh"
	source "${dir}/cld.sh"
	source "${dir}/dict.sh"
	source "${dir}/gfm2docx.sh"
	source "${dir}/mkcd.sh"
	source "${dir}/pem2crt.sh"
	source "${dir}/pps.sh"
fi
unset dir
