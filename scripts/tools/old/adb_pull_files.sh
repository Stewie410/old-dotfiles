#!/bin/bash
#
# adb_pull_files.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-01-26
#
# An automated-ish way for Foofy to pull files from his android device.
# Requires:
# 	android-tools
#	android-udev
#	android-file-transfer
#	mtpfs

# Functions
# Connect ADB
connectADB() { adb wait-for-device; }

# Check Options for Errors
checkOpts() {
	el=0					# "Error" Level

	# Check SRC and DST
	if adb devices | grep -q "device"; then
		# Check Source
		if adb shell "ls $src" | grep -q "No"; then el=1; echo "Error, \"$src\" doesn't exist."; fi
		
		# Check Destination
		if [ "$el" -eq 0 ] && [ ! -d "$dst" ]; then el=1; echo "Error, \"$dst\" doesn't exist."; fi
	fi
	
	echo "$el"
	unset el
}

# Clear Globale Memory
usv() { unset src dst tdl OPTS; }

# Kill ADB Server
kadb() { adb kill-server; }

# Configure the adb_usb.ini file
addUSB() {
	andDir="$HOME/.android"				# Declare ~/.android
	adbINI="$andDir/adb_usb.ini"			# Declare INI file
	el=0						# "Error" level

	# If ~/.android doesn't exist, make it
	if [ ! -d "$andDir" ]; then mkdir -p "$andDir"; fi

	# Check for our MTP device; else report error
	if lsusb | grep -q MTP; then
		# Get our Vendor ID
		vid="$(lsusb | grep MTP | sed -r 's/.*([0-9a-f]{4}):.*/0x\1/')"
		
		# If our adb_usb.ini file isn't there, touch it
		if [ ! -f "$adbINI" ]; then touch "$adbINI"; fi

		# If our Vendor ID isn't in the file, add it
		grep -q "$vid" "$adbINI" || echo "0x$vid" >> "$adbINI";
	else
		el=1
	fi
	
	# Return $el and clear memory
	echo "$el"
	unset andDir adnINI el vid
}

# Show Help
show_help() {
	echo -e "adb_pull_files.sh -- A semi-automated file-grabber for ADB\n\nUsage\n adb_pull_files.sh\n adb_pull_files.sh [options]\n"
	echo "Options:"
	echo " -h, --help                          Show this Help Message"
	echo " -s, --src, --source      <path>     Absolute path to source directory in ADB"
	echo " -d, --dst, --destination <path>     Absolute or Relative path to the destination directory"
	echo ""
}

# Vars
src="/storage/self/primary/DCIM/Camera"		# Source of Pictures and Video
dst="$HOME/Pictures/Android"			# Destination

# Handle arguments
OPTS=$(getopt -o hs:d: --long help,source:,src:,destination:,dst: -n 'adb_pull_files_Args' -- "$@")
eval set -- "$OPTS"
while true; do
	case "$1" in
		-h | --help )
			show_help
			usv
			return 0
			;;
		-s | --src | --source )		
			if [ -n "$2" ] && [[ ! "$2" =~ ^\- ]]; then
				src="$2"
				shift
				shift
			fi
			;;
		-d | --dst | --destination )
			if [ -n "$2" ] && [[ ! "$2" =~ ^\- ]]; then
				if [ -d "$2" ]; then
					dst="$2"
					tdl="$dst/$(echo "$tdl" | awk -F "/" '{print $NF}')"
					shift
					shift
				fi
			fi
			;;
		-- )
			shift
			break
			;;
		* )
			break
			;;
	esac
done

# Prerun Checks
# Ensure ADB is running
connectADB

# Check Options
if [ "$(checkOpts)" -ne 0 ]; then echo "Aborting..."; usv; kadb; return 1; fi

# Check to ensure MTP device is connected
for (( i=0; i<10; i++)); do
	echo -e "Checking for Android Device connected in MTP mode..."
	if [ "$(lsusb | grep -q MTP && echo 0 || echo 1)" -eq 0 ]; then 
		echo "Device found."
		break
	fi
	echo -e "Error:\tNo Device connected..."
	sleep 1
	echo -e "Ensure Developer Mode and USB Debugging is enabled, then reconnect\nyour device."
	echo "..."
	sleep 10
	if [ "$((i + 1))" -ge 10 ]; then
		echo "A critical error has occurred.  Aborting!"
		usv
		kadb
		return 1
	fi
done

# Run
# If all goes well, pull data to temporary destination; then clean up
adb pull "$src/" "$dst" && notify-send -u normal "ADB Pull is done!"

# Add our ADB Device to ADB's known USB devices list
adbUSB

# Clean up memory and quit --> Kill's ADB server
usv
kadb
