#!/usr/bin/env bash
#
# dmenu_sudo.sh
#
# run commands as sudo via dmenu

dmenu_run "${@}" <&- && echo
