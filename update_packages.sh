echo "Writing native package list..."
pacman -Qqettn > ~/git/arch/packages

echo "Writing foreign package list..."
pacman -Qqettm > ~/git/arch/aur_packages
