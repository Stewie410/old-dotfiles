#!/usr/bin/env bash
#
# scriptname.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
# Date: 	YYYY-MM-DD
#
# Description

# ##----------------------------------------------------##
# #| 		                Traps 			            |#
# ##----------------------------------------------------##
trap usv EXIT

# ##----------------------------------------------------##
# #| 		            Functions 		                |#
# ##----------------------------------------------------##
# Cleanup
usv() {
	unset OPTS
}

# Check Options
checkOpts() {
	# Check Variables

	# Normalize Options

	# Check Directories

	# Check Files

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	# Return if no args passed
	[ -n "${2}" ] || return

	# Determine Message
	local msg
	case "${1,,}" in
		null ) 	msg="Variable is undefined";;
		dir ) 	msg="Cannot locate or create directory";;
		file ) 	msg="Cannot locate or overwrite file";;
		* ) 	msg="An unexpected error occurred";;
	esac

	# Print Message
	printf 'ERROR:\t%s:\t%s\n' "${msg}" "${2}" | log
}

# Log message to terminal & file
log() { tee --append "${fileLog}" 2>/dev/null; }

# Show Help/Usage
show_help() {
	cat << EOF
scriptname.sh

Description

Usage: scriptname.sh [options]

    Options:
	-h, --help 		Show this help message
EOF
}

# ##----------------------------------------------------##
# #| 		            Variables 		                |#
# ##----------------------------------------------------##

# ##----------------------------------------------------##
# #| 		        Handle Arguments 	                |#
# ##----------------------------------------------------##
OPTS="$(getopt --options h --longoptions help --name 'scriptname.sh' -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help ) 		show_help; exit;;
		-- ) 			shift; break;;
		* ) 			break;;
	esac
done

# ##----------------------------------------------------##
# #| 		            Pre-Run Tasks 		            |#
# ##----------------------------------------------------##
# Check Options
checkOpts || exit 1

# ##----------------------------------------------------##
# #| 		                Run 			            |#
# ##----------------------------------------------------##
