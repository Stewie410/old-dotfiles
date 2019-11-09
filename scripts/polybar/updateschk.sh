#!/bin/bash
#
# updateschk.sh
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-11-02
#
# Get the total number of available packages since last sync
# Requires:
#	yay
printf '%b\n' " $(yay -Qu | wc --lines)"
