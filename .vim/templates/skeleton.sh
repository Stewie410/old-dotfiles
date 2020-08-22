#!/usr/bin/env bash
#
# scriptname.sh
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
	local msg pre tag
	case "${1,,}" in
		null ) 	tag="CHECK"; msg="Variable is undefined"; pre="1";;
		dir ) 	tag="CHECK"; msg="Cannot locate or create directory"; pre="1";;
		file ) 	tag="CHECK"; msg="Cannot locate or overwrite file"; pre="1";;
        sep )   printf '\n\n%80s\n' " " | tr ' ' "\n" >> "${fileLog}"; return;;
		* ) 	tag="EXCPT"; msg="An unexpected error occurred";;
	esac

	# Print Message
    printf '[%s] [%s] %s: %s' "$(date --iso-8601=sec)" "${tag^^}" "${msg}" "${2}" |& log
}

# Log message to terminal & file
log() { tee --append "${fileLog}" 2>/dev/null; }

# Show Help/Usage
show_help() {
	cat << EOF
${0##*\/}
Description

Usage: scriptname.sh [options]

    Options:
	-h, --help 		Show this help message
EOF
}

# ##----------------------------------------------------##
# #| 		            Variables 		                |#
# ##----------------------------------------------------##
# Paths
fileLog="/var/log/scriptname/$(date --iso-8601).log"

# ##----------------------------------------------------##
# #| 		        Handle Arguments 	                |#
# ##----------------------------------------------------##
OPTS="$(getopt --options h --longoptions help --name "${0##*\/}" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help ) 		show_help; exit;;
		-- ) 			    shift; break;;
		* ) 			    break;;
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
