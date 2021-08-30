#!/usr/bin/env bash
#
# run commands as sudo via dmenu

dmenu_run "${@}" <&- && echo
