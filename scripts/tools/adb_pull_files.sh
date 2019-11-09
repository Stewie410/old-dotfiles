#!/bin/env bash
#
# adb_pull_files.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-03
#
# An automated-ish way for Foofy to pull files from his android device
# Requires:
#	-android-tools
#	-android-udev
#	-android-file-transfer
#	-mtpfs
#	-getopt

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() {
	adb kill-server										# Kill ADB Server
	unset _path_dir_source _path_dir_destination _path_dir_android				# Clear memory
	unset _path_file_usbini
	unset _id_vendor
	unset OPTS
}

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_path_dir_source}" ]; then printErr "null" "_path_dir_source"; return 1; fi
	if [ -z "${_path_dir_destination}" ]; then printErr "null" "_path_dir_destination"; return 1; fi
	if [ -z "${_path_dir_android}" ]; then printErr "null" "_path_dir_android"; return 1; fi
	if [ -z "${_path_file_usbini}" ]; then printErr "null" "_path_file_usbini"; return 1; fi
	if [ -z "${_id_vendor}" ]; then printErr "null" "_id_vendor"; return 1; fi

	# Check for existence of directories
	mkdir --parents _path_dir_destination
	mkdir --parents _path_dir_android

	# Check for existence of files
	touch -a "${_path_file_usbini}"

	# Check for valid Vendor ID Format
	if [[ "${_id_vendor:0:2}" != "0x" ]]; then printErr "id" "Bad VendorID Format:\t${_id_vendor}"; return 1; fi
	if ((${#_id_vendor} > 6)); then printErr "id" "VendorID is too long:\t${_id_vendor}"; return 1; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if no args passed
	local _msg										# Declare local variables
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Null variable
		id )	_msg="VendorID Error";;							# VendorID Format
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Show Help
show_help() {
	printf '%b\n' "adb_pull_files.sh [Options]" "A semi-automated way for to retrieve files from an Android device\n" "Options:"
	printf '\t%s\t\t\t%s\n' "-h, --help" "Show this help message"
	printf '\t%s\t\t<path>\t%s\n' "-s, --dir-src" "Define the absolute path to the source directory"
	printf '\t%s\t\t<path>\t%s\n' "-d, --dir-dst" "Define the absolute path to the destination directory"
	printf '\t%s\t<path>\t%s\n' "-a, --dir-android" "Define the absolute path to the android/adb directory (def: ${HOME}/.android)"
	printf '\t%s\t\t<path>\t%s\n' "-u, --file-ini" "Define the absolute path and name of the ADB USB ini file"
	printf '\t%s\t\t<vid>\t%s\n' "-i, --vid" "Define teh VendorID (eg: 0x1234)"
	printf "\n"
}

# Get Vendor ID
getVendorID() { 
	while true; do
		printf '%s\n' "Checking for Android Device connected in MTP mode..."
		_id_vendor="$(lsusb | grep --ignore-case | sed --regex-extended 's/^.*([0-9a-f]{4}):.*$/0x\1/I')"
		if [ -n "${_id_vendor}" ]; then
			printf '%s\n' "Device Found"
			break
		fi
		printf '%b\n' "ERROR:\tNo device connected..." "Ensure Developer Mode & USB Debugging is enabled, then" "reconnect your device..."
		sleep 10
	done
}

# Add Vendor ID to USB ini file -- Args: $1: VendorID
adbUSB() {
	if [ -z "${1}" ]; then return; fi							# Break if no args passed
	if grep --quiet --ignore-case "${1}" "${_path_file_usbini}"; then return; fi		# Return if already in file
	printf '%s\n' "${1}" >> "${_path_file_usbini}"						# Add Vendor ID to ini file
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Paths -- Directories
_path_dir_source="/storage/self/primary/DCIM/Camera"						# Source of files on Android Device
_path_dir_destination="${HOME}/Pictures/Android"						# Destiniation Directory
_path_dir_android="${HOME}/.android"								# Android directory

# Paths -- Files
_path_file_usbini="${_path_dir_android}/adb_usb.ini"						# Android USB INI file

# IDs
_id_vendor="0x"											# Vendor ID

# ##--------------------------------------------##
# #|		Handle Arguments		|#
# ##--------------------------------------------##
OPTS="$(getopt --options hs:d:a:u:i: --longoptions help,dir-src:,dir-dst:,dir-android:,file-ini:,vid: --name "adb_pull_files" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help )		show_help; exit;;
		-s | --dir-src )	_path_dir_source="${2}"; shift 2;;
		-d | --dir-dst )	_path_dir_destination="${2}"; shift 2;;
		-a | --dir-android )	_path_dir_android="${2}"; shift 2;;
		-u | --file-ini )	_path_file_usbini="${2}"; shift 2;;
		-i | --vid )		_id_vendor="${2}"; shift 2;;
		-- )			shift; break;;
		* )			break;;
	esac
done

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then exit 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Start ADB Server
adb wait-for-device

# Get MTP Device Vendor ID
if ((${#_id_vendor} == 2)); then getVendorID; fi

# Pull files to destination
adb pull "${_path_dir_source}/" "${_path_dir_dst}"
printf '%s\n' "Done!"

# Add device to INI file
adbUSB "${_id_vendor}"
