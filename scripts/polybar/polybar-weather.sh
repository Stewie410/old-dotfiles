#!/usr/bin/env bash
#
# Get the the weather right now

curl --silent --fail "wttr.in/?u&format=%C+%t" | sed 's/+//'
