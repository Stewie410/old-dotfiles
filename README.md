# Dotfiles

My personal configurations & scripts in a linux environment.

This is my collection of conifgurations and settings in a linux environment.  My previous dotfiles repository, [pubrice](https://github.com/Stewie410/pubrice), was never really maintained beyond the initial commit.  This repo is essentially an extension of that, as I've learned more about Linux and how I prefer to use Linux.

## Install

```bash
git clone --bare "https://github.com/Stewie410/dotfiles.git" "${HOME}/dotfiles"
gdf() { git --git-dir="${HOME}/dotfiles" --work-tree="${HOME}" "${@}";  }

if ! gdf checkout &>/dev/null; then
	mkdir --parents "${HOME}/.dotfiles_backup"
	gdf checkout |& awk '/^\s+/ {print gensub(/^\s+/, "", 1, $0)}' | while read -r item
	do
		[[ "${item%/*}" != "${item}" ]] && mkdir --parents "${HOME}/.dotfiles_backup/${item%/*}"
		mv "${item}" "${HOME}/.dotfiles_backup/${item}"
	done
fi

gdf checkout
gdf config status.showUntrackedFiles no
```
