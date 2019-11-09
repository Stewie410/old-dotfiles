#!/bin/env bash
#
# hwstats.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-08-09
#
# Reports current:
#	-Average CPU Temperature
#	-CPU Frequency
#	-RAM Utalizations (%)
# Requires:
#	-lm_sensors
#	-cpupower
#	-calc
#
# TODO	Add logging
# TODO	Add Debug info

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() {
	unset _str_status_icon _str_status_units _str_seperator
	unset _path_dir_log _path_file_log
	unset _opt_force _opt_debug
	unset OPTS
}

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_str_status_icon}" ]; then printErr "null" "_str_status_icon"; return 1; fi
	if [ -z "${_str_status_units}" ]; then printErr "null" "_str_status_units"; return 1; fi
	if [ -z "${_str_seperator}" ]; then printErr "null" "_str_seperator"; return 1; fi
	if [ -z "${_path_dir_log}" ]; then printErr "null" "_path_dir_log"; return 1; fi
	if [ -z "${_path_file_log}" ]; then printErr "null" "_path_file_log"; return 1; fi
	if [ -z "${_opt_force}" ]; then printErr "null" "_opt_force"; return 1; fi
	if [ -z "${_opt_debug}" ]; then printErr "null" "_opt_debug"; return 1; fi
	
	# Normalize options
	if ! [ "${_opt_force}" -ge 0 -a "${_opt_force}" -le 1 ]; then printErr "val" "_opt_force"; _opt_force="0"; fi
	if ! [ "${_opt_debug}" -ge 0 -a "${_opt_debug}" -le 1 ]; then printErr "val" "_opt_debug"; _opt_debug="0"; fi
	
	# Check for "same" strings
	if [[ "${_str_status_icon}" == "${_str_status_units}" ]]; then printErr "str" "_str_status_icon & _str_status_units:\t'${_str_status_icon}'"; return 1; fi
	if [[ "${_str_status_icon}" == "${_str_seperator}" ]]; then printErr "str" "_str_status_icon & _str_seperator:\t'${_str_status_icon}'"; return 1; fi
	if [[ "${_str_status_units}" == "${_str_seperator}" ]]; then printErr "str" "_str_status_units & _str_seperator:\t'${_str_status_units}'"; return 1; fi

	# Check for existence of directories
	if [ ! -d "${_path_dir_log}" ] && [[ "${_path_file_log,,}" != "/dev/null" ]]; then
		if [ "${_opt_force}" -eq 1 ]; then mkdir -p "${_path_dir_log}"; else
			read -p "Create directory '${_path_dir_log}'? (y/N): " mdc
			if [ -n "${mdc}" ] && [[ "${mdc,,}" == "y" ]]; then mkdir -p "${_path_dir_log}"; else
				printErr "dir" "${_path_dir_log}"
				unset mdc
				return 1
			fi
			unset mdc
		fi
	fi
	
	# Check for existence of files
	if [ ! -f "${_path_file_log}" ] && [[ "${_path_file_log,,}" != "/dev/null" ]]; then
		if [ "${_opt_force}" -eq 1 ]; then touch "${_path_file_log}"; else
			read -p "Create file '${_path_file_log}'? (y/N): " mfc
			if [ -n "${mfc}" ] && [[ "${mfc,,}" == "y" ]]; then touch "${_path_file_log}"; else
				printErr "file" "${_path_file_log}"
				unset mfc
				return 1
			fi
			unset mfc
		fi
	fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message Part
printErr() {
	if [ -n "${2}" ]; then
		local _msg="[ERROR]\t"
		case "${1,,}" in
			null )	_msg+="Variable is undefined:\t${2}";;
			val )	_msg+="Bad Option Value:\t${2}\n\tSetting to Default";;
			str )	_msg+="Two or more strings match:\t${2}";;
			dir )	_msg+="Cannot make or find directory:\t${2}";;
			file )	_msg+="Cannot find or make file:\t${2}";;
			* )	_msg+="An unexpected error occurred:\t${2}";;
		esac
		echo -e "${_msg}"
		unset _msg
	fi
}

# Show Help
show_help() {
	printf '%b\n' "hwstatus.sh\t[Options]\n" "Options:"
	printf '\t%s\t\t\t%s\n' "-h, --help" "Show this help message"
	printf '\t%s\t\t\t%s\n' "-f, --force" "Skip confirmation checks"
	printf '\t%s\t\t\t%s\n' "-l, --log" "Enable logging to file"
	printf '\t%s\t%s\t\t%s\n' "-u, --units" "<C/F/K>" "Define the temperature units to display"
	printf '\t%s\t%s\t\t%s\n' "-i, --icon" "<utf8>" "Define the (unicode) icon for the display message"
	printf '\t%s\t%s\t\t%s\n' "-s, --seper" "<str>" "Define the character(s) to use as a seperator for each piece of info"
	printf "\n"
}

# Log message to file -- Args: $1: Message; $2: Log To Terminal (opt; def: 0)
log() {
	if [ -n "${1}" ]; then
		local _ltt="0"
		if [ -n "${2}" ]; then _ltt="${2}"; fi
		if [ "${_opt_debug}" -eq 1 ]; then _ltt="1"; fi
		if [ "${_ltt}" -eq 1 ]; then
			printf '%b\n' "${1}" | tee -a "${_path_file_log}"
		else
			printf '%b\n' "${1}" >> "${_path_file_log}"
		fi
		unset _ltt
	fi
}

# Print Status Message
printStatus() {
	local _tmp="$(getCpuTemp)"
	local _frq="$(getCpuFreq)"
	local _ram="$(getRamUtil)"
	local _ico="${_str_status_icon}"
	local _uni="${_str_status_units}"
	local _sep="${_str_seperator}"
	local _str="${_ico} "
	if [ -n "${_tmp}" ]; then _str+="${_tmp}${_uni}${_sep}"; fi
	if [ -n "${_frq}" ]; then _str+="${_frq}${_sep}"; fi
	if [ -n "${_ram}" ]; then _str+="${_ram}%"; fi
	if [[ "${_str,,}" == "${_ico} " ]]; then _str+="ERROR"; fi
	_str="$(echo "${_str}" | sed 's/ *$//')"
	echo "${_str}"
	unset _tmp _frq _ram _ico _uni _sep _str
}

# Get CPU Temperature
getCpuTemp() { qalc "$(sensors -A | grep -E "^Core" | awk '{SUM += $3} END {print SUM}')/$(sensors | grep -cE "^Core")" | awk '{print $NF}' | xargs printf '%.*f\n' 2; }

# Get CPU Frequency
getCpuFreq() { cpupower frequency-info -fm | awk '/current/ {print $4,$5}'; }

# Get RAM Utilization (%)
getRamUtil() { free | awk '/^Mem/ {print $2/$3}' | xargs printf '%.*f\n' 2; }

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Strings
_str_status_icon=""
_str_status_units="°C"
_str_seperator="  "

# Paths
_path_dir_log="${HOME}/scripts/polybar/log/hwstats"
_path_file_log="/dev/null"

# Options
_opt_force="0"
_opt_debug="0"

# ##--------------------------------------------##
# #|		Handle Arguments		|#
# ##--------------------------------------------##
OPTS="$(getopt -o hfldu:i:s: --long help,force,log,debug,units:,icon:,seper: -n 'hwstats_Args' -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help )	show_help; usv; return 0;;
		-f | --force )	_opt_force="1"; shift;;
		-l | --log )	_path_file_log="$(date +%Y-%m-%d-%H-%M-%S).log"; shift;;
		-d | --debug )	_opt_debug="1"; shift;;
		-u | --units )	_str_status_units="°${2}"; shift 2;;
		-i | --icon )	_str_status_icon="${2}"; shift 2;;
		-s | --seper )	_str_seperator="${2}"; shift 2;;
		-- )		shift; break;;
		* )		break;;
	esac
done

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
if [[ "${_path_file_log,,}" != "/dev/null" ]]; then _path_file_log="${_path_dir_log}/${_path_file_log}"; fi
if ! checkOpts; then usv; return 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
printStatus
usv
