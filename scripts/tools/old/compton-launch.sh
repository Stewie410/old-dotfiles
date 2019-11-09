#!/bin/bash
#
# compton-launch.sh
# Author:	Alex Paarfus <stewie410@me.com>
# Date:		2019-01-20
#
# Like polybar's launch script, but for compton

killall -q compton
while pgrep -x compton >/dev/null; do sleep 1; done

compton &
