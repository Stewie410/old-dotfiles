#!/usr/bin/env bash
#
# extract_archive.sh
#
# Extract various types of archive/compressed files

# Show Usage
usage() { printf '%s\n' "USAGE: ${0##*\/} [-h|--help] FILE1 [FILE2 [...]]"; }

# Check if application exists
exist() { command -v "${1}" || { printMsg "app" "${1}"; return 1; }; }

# Print Message :: String type, String part
printMsg() {
    # Return if no args passed
    [ -n "${2}" ] || return

    # Determine message & tag
    local msg tag
    case "${1,,}" in
        exist )     tag="ERROR"; msg="File does not exist";;
        unknown )   tag="ERROR"; msg="Unrecognize file format";;
        app )       tag="ERROR"; msg="Cannot locate required package/application";;
        * )         tag="EXCPT"; msg="An unexpected error occurred";;
    esac

    # Print Message
    printf '%s\n' "[$(date --iso-8601=sec)] [${tag^^}] ${msg}: ${2}"
}

# Handle Arguments
[ -n "${1}" ] || { usage; exit 1; }
grep --quiet --ignore-case --extended-regexp "-(h|-help)" <<< "${*}" && { usage; exit; }
[ -s "${1}" ] || { printMsg "exist" "${1}"; exit 1; }

# Extract File
case "${1#.*}" in
    tar | tar.xz )      exist "tar" || exit 1; tar --extract --file="${1}";;
    tar.gz | tgz )      ( exist "tar" && exist "gunzip" ) || exit 1; tar --extract --gzip --file="${1}";;
    tar.bz2 | tbz2 )    ( exist "tar" && exist "bzip2" ) || exit 1; tar --extract --bzip2 --file="${1}";;
    tar.zst | zst )     exist "unzstd" || exit 1; unzstd "${1}";;
    bz2 )               exist "bunzip2" || exit 1; bunzip "${1}";;
    gz )                exist "gunzip" || exit 1; gunzip "${1}";;
    rar )               exist "unrar" || exit 1; unrar x "${1}";;
    zip )               exist "unzip" || exit 1; unzip "${1}";;
    Z )                 exist "uncompress" || exit 1; uncompress "${1}";;
    7z )                exist "7z" || exit 1; 7z x "${1}";;
    deb )               exist "ar" || exit 1; ar x "${1}";;
    * )         printMsg "unknown" "${1}"; usage; exit 1;;
esac
