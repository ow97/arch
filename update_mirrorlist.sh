#!/usr/bin/env bash
set -e

if [[ $EUID != 0 ]]; then
    sudo "$0" "$@"
    exit $?
fi

echo "Benchmarking and ranking recently synced mirrors..."
reflector --threads 4 \
    --protocol https --latest 10 \
    --fastest 5 --sort rate \
    --save /etc/pacman.d/mirrorlist

echo "Up to date and ranked mirror list written to /etc/pacman.d/mirrorlist"
echo

while true; do
    read -p "You should do a full system upgrade now! Continue? [yn] " -n 1 yn
    echo
    echo

    case ${yn} in
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
