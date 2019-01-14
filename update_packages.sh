#!/usr/bin/env bash

echo "Cleaning out orphaned dependencies..."
ORPHANS=$(pacman -Qdtq)
if [[ -n "${ORPHANS}" ]]; then
    sudo pacman -Rns ${ORPHANS}
fi

echo "Checking database..."
sudo pacman -Dkk

echo "Writing native package list..."
pacman -Qqettn > ~/git/arch/packages

echo "Writing foreign package list..."
pacman -Qqettm > ~/git/arch/aur_packages

echo
git --no-pager diff -U0 packages aur_packages
echo

while true; do
    read -p "Do you wish to commit those changes? [yn] " -n 1 yn
    echo

    case $yn in
        [Yy]* )
            echo "Committing changes..."
            git commit -m \"Update package lists\" packages aur_packages
            exit;;
        [Nn]* )
            echo "Rolling back changes..."
            git checkout packages aur_packages
            exit;;
        * )
            echo "Please answer y or n" ;;
    esac;
done
