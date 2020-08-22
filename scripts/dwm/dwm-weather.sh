#!/usr/bin/env bash
#
# Get the current weather

curl --silent --fail "wttr.in/?u&format=%C+%t" | sed 's/+//'
