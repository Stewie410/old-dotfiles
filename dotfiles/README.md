## Dotfiles

This is my collection of conifgurations and settings in a linux environment.  My previous dotfiles repository, [pubrice](https://github.com/Stewie410/pubrice), was never really maintained beyond the initial commit.  This repo is essentially an extension of that, as I've learned more about Linux and how I prefer to use Linux.

## System

At this time, I've opted to run Manjaro XFCE, and i3-gaps added on top.  The reasoning behind this is to have a desktop environment available to me when either showing a Linux to a new person; or when performing certain tasks.  However, most of the time, I prefer the workflow allowed by i3-gaps and other tiling window managers.  

```txt
Distribution:		Manjaro XFCE
Desktop Environment:	xfce4
Window Manager:		xfwm, i3-gaps
Bar:			xfce4-panel, polybar
Compositor:		compton-tyrone
Fonts:			monospace,  DejaVu, FontAwesome,siji
Terminal:		rxvt-unicode
Shell:			bash
```

## Install

I'm using git bare repositories for the management of my dotfiles, so installing these dotfiles can be a little less straight-forward that it would be otherwise.  Note that this requires git to be installed for any of the following instructions to be relevant.

```bash
git clone --bare "https://github.com/Stewie410/dotfiles.git" "${HOME}/dotfiles"
gdf() { git --git-dir="${HOME}/dotfiles" --work-tree="${HOME}" $@; }
mkdir --parents "${HOME}/.dotfiles_backup"
gdf checkout
if (($?)); then
	printf '%s\n' "Backing up pre-existing dotfiles to ~/.dotfiles_backup"
	gdf checkout 2>&1 | \
		grep --extended-regexp "\s+\." | \
		awk '{print $1}' | \
		xargs -I {} mv "{}" "${HOME}/.dotfiles_backup/{}"
fi
gdf checkout
gdf config status.showUntrackedFiles no
```
