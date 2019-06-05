#!/usr/bin/env bash
set -e

cd "${0%/*}"
if [[ ! -f packages || ! -f aur_packages ]]; then
    echo "One or more of packages and aur_packages doesn't exist."
    echo "Are we in the right directory? Quitting.."
    exit
fi

echo "Cleaning out orphaned dependencies..."
ORPHANS=$(pacman -Qdtq)
if [[ -n "${ORPHANS}" ]]; then
    sudo pacman -Rns ${ORPHANS}
fi
echo

echo "Checking database..."
sudo pacman -Dkq
echo

echo "Checking install consistency..."
sudo pacman -Qkq
echo

echo "Writing native package list..."
pacman -Qqettn > packages
echo

echo "Writing foreign package list..."
pacman -Qqettm > aur_packages
echo

if git diff --quiet aur_packages packages; then
    echo "No changes to commit! Exiting..."
    exit
fi

git --no-pager diff -U0 packages aur_packages
echo

while true; do
    read -p "Do you wish to commit those changes? [yn] " -n 1 yn
    echo

    case $yn in
        [Yy]* )
            echo "Committing changes..."
            git commit -m "Update package lists" packages aur_packages
            exit;;
        [Nn]* )
            echo "Rolling back changes..."
            git checkout packages aur_packages
            exit;;
        * )
            echo "Please answer y or n" ;;
    esac;
done
