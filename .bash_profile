#!/usr/bin/env bash
#
# Definition of this bash profile

if [ -s "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
else
    source "/etc/profile"
fi
