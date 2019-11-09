#!/bin/bash
#
# weatherchk.sh
# Author:	Alex Paarfus
# Date:		2019-11-02
# 
# Get our current weather conditions via OpenWeatherMap
# Requires:
#	-OpenWeatherMap API Key
#	-jq

# ##----------------------------##
# #|		Traps		|#
# ##----------------------------##
trap usv EXIT

# ##------------------------------------##
# #|		Functions		|#
# ##------------------------------------##
# Cleanup
usv() {
	unset _units_type
	unset _api_url _api_key
	unset _geoip_url
	unset _str_deg _str_sep
}

# Check Options
checkOpts() {
	# Check for null values
	if [ -z "${_units_type}" ]; then printErr "null" "_units_type"; return 1; fi
	if [ -z "${_api_url}" ]; then printErr "null" "_api_url"; return 1; fi
	if [ -z "${_api_key}" ]; then printErr "null" "_api_key"; return 1; fi
	if [ -z "${_geoip_url}" ]; then printErr "null" "_geoip_url"; return 1; fi
	if [ -z "${_str_deg}" ]; then printErr "null" "_str_deg"; return 1; fi
	if [ -z "${_str_sep}" ]; then printErr "null" "_str_sep"; return 1; fi

	# Check API Key
	if ((${#_api_key} < 32)); then printErr "api" "API Key is too short"; return 1; fi
	if echo "${_api_key,,}" | grep --quiet "[^0-9a-f]"; then printErr "api" "API Key contains invalid characters"; return 1; fi

	# Check for network connectivity
	if ping -c 1 "8.8.8.8" 2>&1 | grep --ignore-case --quiet "unreachable"; then return 1; fi

	# Check for server availability
	if ! curl --silent "${_api_url}" | grep --ignore-case --quiet "invalid api key"; then printErr "url" "Invalid OpenWeatherMap API URL:\t${_api_url}"; return 1; fi
	if ! curl --silent --fail "${_geoip_url}" >/dev/null; then printErr "url" "Invalid GeoIP URL:\t${_geoip_url}"; return 1; fi

	# Return Success
	return 0
}

# Print Errors -- Args: $1: Type; $2: Message
printErr() {
	if [ -z "${2}" ]; then return; fi							# Break if no args passed
	local _msg										# Declare local variables
	case "${1,,}" in
		null )	_msg="Variable is undefined";;						# Null Variable
		api )	_msg="OpenWeatherMap Error";;						# OWM/API Error
		net )	_msg="Network Connection Error";;					# Network Connection
		url )	_msg="URL Error";;							# URL Errors
		* )	_msg="An undexpected error occurred";;					# All other errors
	esac
	printf '%b\n' "ERROR:\t${_msg}:\t${2}"							# Print Error
}

# Get Weather Icon -- Args: $1: Weather String
getWeatherIcon() {
	if [ -z "${1}" ]; then return; fi							# Break if no args passed
	local _ico _val										# Declare local vars
	_val="${1,,}"; _val="${_val/\"/}"							# Set _val to lcase($1)
	if ((${_val:0:1} == 0)); then
		case "${_val:1:1}" in
			1 )	_ico="";;							# Clear
			[234] )	_ico="";;							# Cloudy
			9 )	_ico="";;							# Wind and Rain
			* )	_ico="X";;							# Default
		esac
	elif ((${_val:0:1} == 1)); then
		case "${_val:1:1}" in
			0 )	_ico="";;							# Rain
			1 )	_ico="";;							# Lightning
			3 )	_ico="";;							# Snow
			* )	_ico="X";;							# Default
		esac
	elif ((${_val:0:1} == 5)); then
		case "${_val:1:1}" in
			0 )	_ico="f";;							# Fog
			* )	_ico="X";;							# Default
		esac
	fi
	echo "${_ico}"										# Return Icon
}

# Get Trend Icon -- Args: $1: Current Temp; $2: Next Temp
getTrendIcon() {
	if [ -z "${2}" ]; then return; fi							# Break if no args passed
	local _ico _c _n									# Declare local variables
	_c="${1/[^0-9]/}"; _n="${2/[^0-9]/}"							# Get Args in parseable format
	if ((_c < _n)); then									# If trending up
		_ico="<"
	elif ((_c > _n)); then									# If trending down
		_ico=">"
	else
		_ico="="									# If no change
	fi
	echo "${_ico}"										# Return Icon
}

# Get Units Icon -- Args: $1: Units Name
getUnitIcon() {
	if [ -z "${1}" ]; then return; fi							# Break if no args passed
	local _ico										# Declare local variables
	case "${1,,}" in
		imperial )	_ico="F";;							# Imperial
		metric )	_ico="C";;							# Metric
		* )		_ico="K";;							# Kelvin
	esac
	echo "${_ico}"										# Return Icon
}

# Get Coordinates of current GeoIP
getLocation() { curl --silent --fail "${_geoip_url}" | jq '.location' | sed 's/,//g' | awk '/lat/ {lat=$NF} /lng/ {print lat,$NF}'; }

# Get Current Weather Conditions
getCurrentWeather() {
	local _out _json _loc _url 								# Declare local variables
	_loc="$(getLocation)"									# Get current coordinates
	_url="weather?appid=${_api_key}"							# Build REST Query -- Add API key
	_url+="&lat=$(echo "${_loc}" | awk '{print $1}')"					# Add Latitude
	_url+="&lon=$(echo "${_loc}" | awk '{print $2}')"					# Add Longitude
	_url+="&units=${_units_type}"								# Add Units
	_json="$(curl --silent --fail "${_api_url}/${_url}")"					# Get OWM JSON data
	_out="$(echo "${_json}" | jq --raw-output '.weather[0].icon')"				# Get Icon Code
	_out="$(getWeatherIcon "${_out}") "							# Get Weather Icon
	_out+="$(echo "${_json}" | jq '.main.temp' | cut --delimiter='.' --fields=1)"		# Get Temperature from JSON
	echo "${_out}"										# Return Current Conditions
}

# Get Next-Day Weather Conditions
getNextWeather() {
	local _out _json _loc _url 								# Declare local variables
	_loc="$(getLocation)"									# Get current coordinates
	_url="forecast/daily?appid=${_api_key}"							# Build REST Query -- Add API key
	_url+="&lat=$(echo "${_loc}" | awk '{print $1}')"					# Add Latitude
	_url+="&lon=$(echo "${_loc}" | awk '{print $2}')"					# Add Longitude
	_url+="&units=${_units_type}"								# Add Units
	_url+="&cnt=1"										# Add identifier for next-day forecast
	_json="$(curl --silent --fail "${_api_url}/${_url}")"					# Get OWM JSON data
	_out="$(echo "${_json}" | jq --raw-output '.list[].weather[0].icon') "			# Get Weather Icon Code
	_out="$(getWeatherIcon "${_out}") "							# get Weather Icon
	_out+="$(echo "${_json}" | jq '.list[].temp.day' | cut --delimiter='.' --fields=1)"	# Get Temperature from JSON
	echo "${_out}"										# Return Next-Day Conditions
}

# Get Weather String
getWeather() {
	local _wcur _wfor _unit _wtr								# Declare local variables
	_wcur="$(getCurrentWeather)"								# Get current weather
	_wfor="$(getNextWeather)"								# Get weather forecast
	_unit="${_str_deg}$(getUnitIcon "${_units_type}")"					# Get Units Icon
	_wtr="${_wcur}${_unit}${_str_sep}"							# Add Current
	_wtr+="$(getTrendIcon "${_wcur##* }" "${_wfor##* }")${_str_sep}"			# Add Trend Icon
	_wtr+="${_wfor}${_unit}"								# Add Forecast
	echo "${_wtr}"										# Return String
}

# ##------------------------------------##
# #|		Variables		|#
# ##------------------------------------##
# Weather Options
_units_type="imperial"										# Type of Units to return

# OpenWeatherMap
_api_url="https://api.openweathermap.org/data/2.5"						# OpenWeatherMap REST API URL
_api_key="75582c19fd1575286cc8e486712751f5"							# OpenWeatherMap API Key

# GeoIP
_geoip_url="https://location.services.mozilla.com/v1/geolocate?key=geoclue"			# GeoIP URL

# Strings
_str_deg="°"											# Degrees Symbol
_str_sep="  "											# Seperator

# ##------------------------------------##
# #|		Pre-Run Tasks		|#
# ##------------------------------------##
# Check Options
if ! checkOpts; then echo ""; exit 1; fi

# ##----------------------------##
# #|		Run		|#
# ##----------------------------##
# Get Weather String
printf '%b\n' "$(getWeather)"
