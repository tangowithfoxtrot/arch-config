# About this project
This is an attempt to create a declarative configuration for my Arch Linux system because I hate configuration drift and repeating myself.

If you're interested in understanding how some of it "works", I'm using this command to list packages explicitly installed by me (ie. not package dependencies):

`pacman -Qnqe | sort | sed 's/^/  - /g`

And a variation of that, which lists packages explicitly installed by me, but that are not in the official Arch repos (ie. installed with `yay`):

`pacman -Qme | cut -f 1 -d ' ' | sort | sed 's/^/  - /g`

I redirect the output of those into `pkglist.yml` and `pkglist_aur.yml` files, combine, and sort the package list. Then, I use the `imperative_deletion.sh` script to remove packages that were not declared in `./vars/packages.yml`. This script gets ran by `imperative-deletion.service`, a systemd service that runs on boot.

The end result is that any packages installed imperatively get removed by the next boot. It's an incomplete, hacky solution, but I plan to clean this up to make it easier to use and expand the functionality to more than just declarative package management.

## Setup
Install `ansible`

## Run
`./start.sh`
