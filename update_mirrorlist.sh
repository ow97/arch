#!/usr/bin/env bash
set -e

if [[ $EUID != 0 ]]; then
    sudo "$0" "$@"
    exit $?
fi

echo "Getting and ranking up to date mirror list..."
curl -s 'https://www.archlinux.org/mirrorlist/?country=GB&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on' | \
    sed -e 's/^#Server/Server/' -e '/^#/d' | \
    rankmirrors -n 8 - > \
    /etc/pacman.d/mirrorlist

echo "Up to date and ranked mirror list written to /etc/pacman.d/mirrorlist"

while true; do
    read -p "You should do a system upgrade now [yn] " -n 1 yn
    echo

    case $yn in
        [Yy]* )
            pacman -Syyuu
            exit;;
        [Nn]* )
            echo "Ensure your next update is done with double u flag!"
            echo "e.g. pacman -Syyuu"
            exit;;
        * )
            echo "Please answer y or n" ;;
    esac;
done
