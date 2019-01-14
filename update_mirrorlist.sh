#!/usr/bin/env bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

echo "Getting and ranking up to date mirror list..."

curl -s 'https://www.archlinux.org/mirrorlist/?country=GB&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on' | \
    sed -e 's/^#Server/Server/' -e '/^#/d' | \
    rankmirrors -n 8 - > \
    /etc/pacman.d/mirrorlist

echo "Up to date and ranked mirror list written to /etc/pacman.d/mirrorlist"