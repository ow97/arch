#!/usr/bin/env bash
bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold}Cleaning out uneeded dependencies...${normal}"
pacman -Qdtq | sudo pacman -Rns - >/dev/null 2>&1

echo "${bold}Writing native package list...${normal}"
pacman -Qqettn > ~/git/arch/packages

echo "${bold}Writing foreign package list...${normal}"
pacman -Qqettm > ~/git/arch/aur_packages

echo "${bold}Committing updated package lists...${normal}"
git commit -m "Update package lists" packages aur_packages

echo "${bold}Complete! You may want to git push${normal}"
