#!/bin/env bash
#
# autoscrot.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-10-26
#
# Takes a screenshot with scrot && stores it in the specified location
# Requires:
#	-scrot

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() { unset _path_dir_dst _file_base _file_type; }

# Check Options
checkOpts() {
	# Check for null variables
	if [ -z "${_path_dir_dst}" ]; then printErr "null" "_path_dir_dst"; return 1; fi
	if [ -z "${_file_base}" ]; then printErr "null" "_file_base"; return 1; fi
	if [ -z "${_file_type}" ]; then printErr "null" "_file_type"; return 1; fi

	# Check for the existence of directories
	if [ ! -d "${_path_dir_dst}" ]; then mkdir -p "${_path_dir_dst}"; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	local _msg										# Error Message
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Null Variable
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:]t${_msg}:\t${2}"							# Print Error
}

# Get File Count
getCount() {
	find "${_path_dir_dst}" -mindepth 1 -maxdepth 1 -type f -name "${_file_base}*.${_file_type}" printf '%f\n' | \
		wc -l 
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Paths -- Directories
_path_dir_dst="${HOME}/Pictures/Screenshots"							# Destination Directory

# File String Components
_file_base="capture"										# Base Filename
_file_type="png"										# Filetype

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then return 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
scrot "${_path_dir_dst}/${_file_base}_$(getCount).${_file_type}
