#!/usr/bin/env bash
#
# adb_pull_files.sh
# Author: 	Alex Paarfus <stewie410@gmail.com>
# Date: 	2020-04-11
# 
# A Semi-Automated way to pull files from Android Device
# Requires:
# 	-lsub
# 	-adb

# ##------------------------------------##
# #| 		Traps 			|#
# ##------------------------------------##
trap usv EXIT

# ##------------------------------------##
# #| 		Functions 		|#
# ##------------------------------------##
# Cleanup
usv() {
	# Kill ADB Server
	adb kill-server |& log

	# Clear Memory
	unset OPTS dirSrc dirDst fileIni fileLog id
}

# Check Options
checkOpts() {
	# Check Variables
	[ -n "${dirSrc}" ] || { printErr "null" "dirSrc"; return 1; }
	[ -n "${dirDst}" ] || { printErr "null" "dirDst"; return 1; }
	[ -n "${fileIni}" ] || { printErr "null" "fileIni"; return 1; }
	[ -n "${fileLog}" ] || { printErr "null" "fileLog"; return 1; }
	
	# Check Directories
	mkdir --parents "${dirDst}" "${fileIni%\/*}" "${fileLog%\/*}"

	# Check Files
	touch "${fileIni}" "${fileLog}"

	# Check required packages
	for i in "lsusb" "adb"; do command -v "${i}" >/dev/null || { printErr "pkg" "${i}"; return 1; }; done

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
		pkg ) 	msg="Required command not found";;
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
adb_pull_files.sh

A Semi-Automated way to pull files from Android Device

Usage: adb_pull_files.sh [options]

    Options:
	-h, --help 		Show this help message
	-s, --src <dir> 	Specify the source path
	-d, --dst <dir> 	Specify the destination path
	-f, --ini <file> 	Specify the ADB INI file path
	-i, --id <vid> 		Specify the Vendor ID
EOF
}

# Get Vendor ID
getID() {
	# Get Vendor ID from INI file
	[ -s "${fileIni}" ] && grep "0x" "${fileIni}" && return

	# Get Vendor ID from connected devices
	lsusb | \
		sed --quiet '/MTP/p' | \
		sed --regexp-extended 's/.*([a-f0-9]{4}):.*/0x\1/I' | \
		tee "${fileIni}" | log
}

# ##------------------------------------##
# #| 		Variables 		|#
# ##------------------------------------##
# Paths
dirSrc="/storage/self/primary/DCIM/Camera"
dirDst="${HOME}/Pictures/Android"
fileIni="${HOME}/.android/adb_usb.ini"
fileLog="/var/log/adb_pull_files/$(date --iso-8601).log"

# Vendor
id=""

# ##------------------------------------##
# #| 		Handle Arguments 	|#
# ##------------------------------------##
OPTS="$(getopt --options hs:d:f:i: --longoptions help,src:,dst:,ini:,id: --name 'adb_pull_files.sh' -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help ) 		show_help; exit;;
		-s | --src ) 		dirSrc="${2}"; shift 2;;
		-d | --dst ) 		dirDst="${2}"; shift 2;;
		-f | --ini ) 		fileIni="${2}"; shift 2;;
		-i | --id ) 		id="${2}"; shift 2;;
		-- ) 			shift; break;;
		* ) 			break;;
	esac
done

# ##------------------------------------##
# #| 		Pre-Run Tasks 		|#
# ##------------------------------------##
# Check Options
checkOpts || exit 1

# ##------------------------------------##
# #| 		Run 			|#
# ##------------------------------------##
# Get Vendor ID if not set
[ -n "${id}" ] || id="$(getID)"

# Pull Files
adb wait-for-device | log
adb pull "${dirSrc}/" "${dirSrc}" | log
