#!/usr/bin/env bash
#
# Use wf-recorder, slurp, zenity and ffmpeg to create a gif

cleanup() {
	rm --recursive --force "${stage}"
	umask 022
	unset stage
}

show_help() {
	cat << EOF
Use wf-recorder, slurp, zenity and ffmpeg to create a gif

USAGE: ${0##*/} [OPTIONS]

OPTIONS:
	-h, --help				Show this help message
	-q, --quiet				Do not write anything to standard output
	-t, --timeout TIME		Specify the TIME to wait before auto-killing wf-recorder
	-T, --no-timeout		Do not auto-kill wf-recorder
	-o, --outfile FILE		Specify the output FILE (default: ~/Videos/YYYY-MM-DDThh:mm:ss.gif)
EOF
}

checkRequirements() {
	for i in "wf-recorder" "slurp" "ffmpeg"; do
		if ! command -v "${i}" &>/dev/null; then
			printf '%s\n' '%s\n' "Missing required package: '${i}'" >&2
			return 1
		fi
	done

	if [[ -z "${WAYLAND_DISPLAY}" ]]; then
		printf '%s\n' "Requires Wayland!" >&2
		return 1
	fi

	return 0
}

stopRecorder() {
	pkill --euid "${USER}" --signal "SIGINT" "wf-recorder"
}

record() {
	local coords capture palette
	capture="${stage}/cap.mp4"
	palette="${stage}/pal.png"

	stopRunningRecorder

	umask 177

	coords="$(slurp)" || return 1

	printf '%s\n' "Starting region capture..."
	if ! timeout "${timeout}" wf-recorder -g "${coords}" "${capture}"; then
		printf '%s\n' "Aborting forgotten capture!" >&2
		stopRunningRecorder &>/dev/null
		return 1
	fi

	printf '%s\n' "Generating palette file..."
	if ! ffmpeg -i "${capture}" -filter_complex "palettegen=stats_mode=full" "${palette}" -y; then
		printf '%s\n' "Failed to generate palette file!" >&2
		return 1
	fi

	umask 022

	mkdir --parents "${outfile%/*}"

	printf '%s\n' "Generating gif..."
	if ! ffmpeg -i "${capture}" -i "${palette}" -filter_complex "paletteuse=dither=sierra2_4a" "${outfile}" -y; then
		printf '%s\n' "Failed to generate gif!" >&2
		return 1
	fi

	return 0
}

main() {
	local opts outfile timeout quiet
	outfile="${HOME}/Videos/$(date --iso-8601=sec).gif"
	timeout="600"

	opts="$(getopt --options hqo:iTt: --longoptions help,quiet,outfile:,timeout:,no-timeout --name "${0##*/}" -- "${@}")"
	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )		show_help; return 0;;
			-t | --timeout )	timeout="${2}"; shift;;
			-o | --outfile )	outfile="${2}"; shift;;
			-T | --no-timeout ) timeout="0";;
			-q | --quiet )		quiet="1";;
			-- )				shift; break;;
			* )					break;;
		esac
		shift
	done

	if [[ -n "${quiet}" ]]; then
		record > /dev/null || return
	else
		record || return
	fi

	return 0
}

checkRequirements
stage="$(mktemp --directory)"
trap cleanup EXIT

main "${@}"
