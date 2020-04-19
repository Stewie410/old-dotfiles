#!/usr/bin/env bash
#
# xrbrightness.sh
# Author:	Alex Paarfus <stewie410@gmail.com>
# Date:		2019-11-03
#
# This is a workaround to adjust the gamma of eDP1 in lieu of xbacklight working as expected
# Requires:
#	-getopt
#	-xrandr
#	-qalc

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() {
	unset _amt_delta
	unset _opt_increase _opt_decrease _opt_reset
	unset OPTS
}

# Check Options
checkOpts() {
	# Check for null variables
	if [ -z "${_amt_delta}" ]; then printErr "null" "_amt_delta"; return 1; fi
	if [ -z "${_opt_increase}" ]; then printErr "null" "_opt_increase"; return 1; fi
	if [ -z "${_opt_decrease}" ]; then printErr "null" "_opt_decrease"; return 1; fi
	if [ -z "${_opt_reset}" ]; then printErr "null" "_opt_reset"; return 1; fi

	# Normalize Options
	if ((_opt_increase < 0)); then _opt_increase="0"; elif ((_opt_increase > 1)); then _opt_increase="1"; fi
	if ((_opt_decrease < 0)); then _opt_decrease="0"; elif ((_opt_decrease > 1)); then _opt_decrease="1"; fi
	if ((_opt_reset < 0)); then _opt_reset="0"; elif ((_opt_reset > 1)); then _opt_reset="1"; fi

	# Check for commands/packages
	if ! command -v getopt >/dev/null 2>&1; then printErr "pkg" "getopt"; return 1; fi
	if ! command -v xrandr >/dev/null 2>&1; then printErr "pkg" "xrandr"; return 1; fi
	if ! command -v qalc >/dev/null 2>&1; then printErr "pkg" "qalc"; return 1; fi

	# Check Delta
	if ((_opt_increase)) || ((_opt_decrease)); then
		if qalc "${_amt_delta} <= 0.0"; then printErr "amt" "Change amount cannot be 0 or less"; return 1; fi
		if qalc "${_amt_delta} > 1.0"; then printErr "amt" "Change amount cannot be 1 or more"; return 1; fi
	fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if args not passed
	local _msg										# Declare local variables
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Variable is undefined
		pkg )	_msg="Cannot locate package/command";;					# Missing Package/Command
		amt )	_msg="Amount Delta Error";;						# Delta
		* )	_msg="An unexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Show Help
show_help() {
	printf '%b\n' "xrbrightness.sh [Options]" "Workaround to adjust gamma when xbacklight is non-functional\n" "Options"
	printf '\t%s\t\t\t%s\n' "-h, --help" "Show this help message"
	printf '\t%s\t\t\t%s\n' "-i, --increase" "Increase the gamma"
	printf '\t%s\t\t\t%s\n' "-d, --decrease" "Decrease the gamma"
	printf '\t%s\t\t\t%s\n' "-r, --reset" "Reset the gamma to 50%"
	printf '\t%s\t<dec>\t\t%s\n' "-a, --amount" "Amount to adjust the brightness by (0.0 to 0.1)"
	printf "\n"
}

# Increase Brightness -- Args: $1: Amount
xbIncrease() {
	if [ -z "${1}" ]; then return; fi							# Break if args not passed
	local _current _next									# Declare local variables
	_current="$(xrandr --current --verbose | awk '/Brightness/ {print $2}')"		# Get current gamma level
	_next="$(qalc --terse "${_current} + ${1}")"						# Get "next" level
	if ((${_current:0:1})); then return; fi							# Break if current is 1
	xrandr --output "eDP1" --brightness "${_next}"						# Increase gamma
}

# Decrease Brightness -- Args: $1: Amount
xbDecrease() {
	if [ -z "${1}" ]; then return; fi							# Break if args not passed
	local _current _next									# Declare local variables
	_current="$(xrandr --current --verbose | awk '/Brightness/ {print $2}')"		# Get current gamma level
	_next="$(qalc --terse "${_current} - ${1}")"						# Get "next" level
	if [[ "${_current}" == 0.0 ]]; then return; fi						# Break if current is 0.0
	xrandr --output "eDP1" --brightness "${_next}"						# Increase gamma
}

# Reset Brightness (50%)
xbReset() {
	local _current										# Declare local variables
	_current="$(xrandr --current --verbose | awk '/Brightness/ {print $2}')"		# Get current gamma level
	if [[ "${_current}" == 0.5 ]]; then return; fi						# Break if current is 0.5
	xrandr --output "eDP1" --brightness "0.5"						# Reset Gamma
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Amounts
_amt_delta="0"											# Amount to change

# Options
_opt_increase="0"										# Increase Brightness
_opt_decrease="0"										# Decrease Brightness
_opt_reset="0"											# Reset to "medium" Brightness

# ##--------------------------------------------##
# #|		Handle Arguments		|#
# ##--------------------------------------------##
OPTS="$(getopt --options hidra: --longoptions help,increase,decrease,reset,amount: --name "xrbrightness" -- "${@}")"
eval set -- "${OPTS}"
while true; do
	case "${1}" in
		-h | --help )		show_help; exit;;
		-i | --increase )	_opt_increase="1"; _opt_decrease="0"; _opt_reset="0"; shift;;
		-d | --decrease )	_opt_increase="0"; _opt_decrease="1"; _opt_reset="0"; shift;;
		-r | --reset )		_opt_increase="0"; _opt_decrease="0"; _opt_reset="1"; shift;;
		-a | --amount )		_amt_delta="${2}"; shift 2;;
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
# Increase Brightness
if ((_opt_increase)); then xbIncrease "${_amt_delta}"; exit; fi

# Decrease Brightness
if ((_opt_decrease)); then xbDecrease "${_amt_delta}"; exit; fi

# Reset Brightness
if ((_opt_reset)); then xbReset; fi
