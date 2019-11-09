#!/bin/bash
#
# oiUpdate.sh
# Author:	Alex Paarfus <apaarfus@wtcox.com>
# Date:		2019-03-22
#
# Pulls an image down from the web, and updates Outlook signatures with the new file

# Functions
# Clear Memory
usv() { unset sigimg sigdir sigexl sigone tmpdir cursha curimg newsha newimg force; }

# Check Options
checkOpts() {
	rv="1"		# Return Value

	echo "$rv"
}

# Show Help
show_help() {
	echo -e "oiUpdate.sh [Options]\n\nOptions:"
	echo -e "\t-h, --help\t\t\tShow this Help Message"
	echo
}

# Pull File
pullFile() { wget "$sigimg" -qO "$tmpdir/$newimg"; }

# Generate Hash -- $1 = src, $2 = dst
genSha() { if [ -n "$1" ] && [ -n "$2" ]; then sha256sum "$1" | awk '{print $1}' > "$2"; fi; }

# Same Hash? -- $1 = File1, $2 = File2
sameSha() { if [[ "$1" == "$2" ]]; then echo 0; else echo 1; fi; }

# Pull Backup
pullTar() { 
	if [ -f "$tmpdir/$bkupf" ]; then rm -f "$tmpdir/$bkupf"; fi
	# Pull TARBALL
}

# Vars
sigimg="http://appserv.wtcox.com/img/sigimg.png"		# Image to pull down
sigdir="/c/Users/$USER/AppData/Roaming/Microsoft/Signatures"	# Location of Outlook's Signatures
sigexl=()							# List of Signatures to exclude
sigone=""							# Specific Signature to target
tmpdir="$sigdir/oiUpdate"					# Working directory
cursha="Image001.sha"						# Current file's SHA256SUM
curimg="Image001.png"						# Current Image file
newsha="img.sha"						# New file's SHA256SUM
newimg="img.png"						# New Image File
bkupf="sigs.tar.gz"						# Tarball location
force="0"							# Force kill Outlook?

# Handle Options
OPTS=$(getopt -o hfu:s: --long help,force,url:,sig: -n 'oiUpdateArgs' -- "$@")
eval set -- "$OPTS"
while true; do
	case "$1" in
		-h | --help )		show_help; usv; return 0;;
		-f | --force )		force="1"; shift;;
		-u | --url )		sigimg="$2"; shift; shift;;
		-s | --sig )		sigone="$2"; shift; shift;;
		-x | --exclude )	sigexl=($(echo "$2" | sed 's/,/ /g')); shift; shift;;
	esac
done

# Check Options
if [ "$(checkOpts)" -ne 0 ]; then usv; return 1; fi

# Run

# Clear memory and quit
usv
