# Dotfiles

My personal configurations & scripts in an Ubuntu-WSL2 environment.
This also _assumes_ [wsl-vpnkit](https://github.com/sakai135/wsl-vpnkit) is
both installed and ready to start from within WSL2.

## Install

```bash
git clone --bare "https://github.com/Stewie410/dotfiles.git" "${HOME}/dotfiles"
gdf() { git --git-dir="${HOME}/dotfiles" --work-tree="${HOME}" "${@}";  }

if ! gdf checkout wsl2 &>/dev/null; then
	mkdir --parents "${HOME}/.dotfiles_backup"
	gdf checkout wsl2 |& awk '/^\s+/ {print gensub(/^\s+/, "", 1, $0)}' | while read -r item
	do
		[[ "${item%/*}" != "${item}" ]] && mkdir --parents "${HOME}/.dotfiles_backup/${item%/*}"
		mv "${item}" "${HOME}/.dotfiles_backup/${item}"
	done
fi

gdf checkout wsl2
gdf config status.showUntrackedFiles no
```
