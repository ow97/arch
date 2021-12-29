#!/usr/bin/env bash
set -e

if [[ $EUID != 0 ]]; then
    sudo "$0" "$@"
    exit $?
fi

echo "Cleaning orphaned packages..."
pacman --noconfirm -Rns -- $(pacman -Qtdq) 2>/dev/null || true
echo "Cleaning package caches..."
paccache -r -k1
for dir in /home/*/.cache/pikaur/pkg; do
	paccache -r -k1 -c "$dir"
done

echo "Cleaning pikaur build and package caches..."
for dir in /home/*/.cache/pikaur /var/cache/private/pikaur; do
	cd "$dir/build"
	ls | while read pkgname; do
		if ! pacman -Q "$pkgname" &>/dev/null; then
			rm -rfv "$pkgname"
		fi
	done
	cd "$dir/pkg"
	ls | while read pkgfile; do
		if ! pacman -Q $(pacman -Q --file "$pkgfile" | cut -f1 -d' ') &>/dev/null; then
			rm -v "$pkgfile"
		fi
	done
done

echo
echo "Big packages:"
#pacgraph -c | sed 's/B /\t/g' | sort -h | tail -n40
pacman -Qtq | while read package; do
	echo $(pacman -Rs --print-format '%s' "$package" | awk '{size+=$1} END {print size}') "$package"
done | sort -n | tail -n20 | numfmt --to=iec


echo
echo "Big possible temporary files and folders:"
du / -ah 2>/dev/null | egrep -i '(cache|build|tmp|downloads?)(/|$)' | sort -h | tail -n40

