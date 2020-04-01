# D☼╪s

## Overview

* Arch Linux dots configuration for suckless [dwm](http://suckless.org/)
* EFISTUB btrfs zstd Arch Linux Installation [Guide](https://github.com/koltea/dots/blob/master/.github/INSTALL.md)
* [Dependencies](https://github.com/koltea/dots#dependencies)

![Rice screen preview0000](https://i.imgur.com/4GnjvU4.png)
![Rice screen preview0001](https://i.imgur.com/8gc85ut.png)

## My Dots using git bare

- Define the alias in the current shell scope:
    - `alias dot='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'`
- Set source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:
    - `echo "dots" >> .gitignore`
- Clone this repo:
    - `git clone --bare https://github.com/koltea/dots.git $HOME/dots`
- Remove stock configuration in $HOME, else error will occur.
- Checkout the actual content from the bare repository to your $HOME.
    - `dot checkout`
- Set the flag showUntrackedFiles to no on this specific (local) repository.
    - `dot config --local status.showUntrackedFiles no`
- Push and set origin master:
    - `dot push -u origin master`


## Dependencies
Package name | Description
:--- | :---
[dwm](http://suckless.org/) | dynamic window manager for X
[st](http://st.suckless.org/) | simple terminal implementation for X
[dmenu](http://tools.suckless.org/dmenu/) | dynamic menu for X
xorg-server | X graphical server
xorg-xinit | starts the graphical server
picom | compositor for X11
xwallpaper | wallpaper setting utility for X
sxiv | simple X Image viewer
xdg-user-dirs | manage user directories
xclip | command line interface to the X11 clipboard
neovim | fork of Vim aiming to improve user experience
exa | improved ls
vifm | vim-like file manager
dunst | lightweight notification-daemon
python-ueberzug | generates image preview for vifm
alsa-utils | audio interface for alsa
mpd | lightweight music daemon
mpc | terminal interface for mpd
mpv | open source and cross-platform media player
ncmpcpp | ncurses interface for music
neomutt | terminal mail clent
qutebrowser | keyboard-driven, vim-like browser
ttf-linux-libertine |  sans and serif fonts
[firacode](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) | main font used
zathura | minimalistic vim-like document viewer
zathura-pdf-mupdf | PDF support for zathura

