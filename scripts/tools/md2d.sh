#!/usr/bin/env bash
#
# Convert Markdown to other document formats (requires pandoc)

show_help() {
	cat << EOF
Convert Markdown to other document formats, by default DOCX

USAGE: ${0##*/} [OPTIONS] FILE

OPTIONS:
    -h, --help              Show this help message
    -r, --reference PATH    Specify another reference file
                            default: '${defaults[reference]}'
    -o, --outfile PATH      Specify the output file
                            default: Place in the same directory with the same
                                     name as FILE, but with the new extension
    -R, --no-reference      Do not use a reference file
        --from-normal       Assume input format is "normal" markdown
        --to-doc            Convert to legacy ".doc" format
        --to-pdf            Convert to PDF
        --to-html           Convert to HTML/web

EOF
}

convmd() {
	local -a args

	args+=( "--from=\"${settings[from]}\"" )
	args+=( "--to=\"${settings[to]}\"" )
	args+=( "--out=\"${settings[outfile]}\"" )
	[[ -n "${settings[reference]}" ]] && args+=( "--reference-doc=\"${settings[reference]}\"" )
	args+=( "\"${*}\"" )

	eval set -- "${args[@]}"
	pandoc "${@}"
}

main() {
	local -A defaults settings
	local opts i
	opts="$(getopt \
		--options hr:R \
		--longoptions help,reference:,no-reference,from-normal,to-doc,to-pdf,to-html \
		--name "${0##*/}" \
		-- "${@}" \
	)"

    defaults[reference]="${WINHOME:-${HOME}}/.config/gfm2docx/reference.docx"
	defaults[from]="gfm"
	defaults[to]="docx"

	for i in "${!defaults[@]}"; do settings["${i}"]="${defaults[${i}]}"; done

	eval set -- "${opts}"
	while true; do
		case "${1}" in
			-h | --help )			show_help; return 0;;
			-r | --reference )		settings[reference]="${2}"; shift;;
			-R | --no-reference )	settings[reference]="";;
			--from-normal )			settings[from]="md";;
			--to-doc )				settings[to]="doc";;
			--to-pdf )				settings[to]="pdf";;
			--to-html )				settings[to]="html";;
			-- )					shift; break;;
			* )						break;;
		esac
		shift
	done

	if ! command -v pandoc &>/dev/null; then
		printf '%s\n' "Pandoc must be installed & in path" >&2
		return 1
	fi

	if [[ -z "${*}" ]]; then
		printf '%s\n' "No file specified" >&2
		return 1
	elif ! [[ -s "${*}" ]]; then
		printf '%s\n' "File does not exist or is empty" >&2
		return 1
	fi

	[[ -n "${settings[outfile]}" ]] || settings[outfile]="${*%.*}.${settings[to],,}"
	[[ "${settings[outfile]%/*}" != "${settings[outfile]}" ]] && mkdir --parents "${settings[outfile]%/*}"

	convmd "${*}"
}

main "${@}"
