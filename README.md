# Arch Linux installation scripts

Perform the following steps manually

    loadkeys uk

    fdisk /dev/sda
        n
        p
        <Enter> * 3
        w
    mkfs.ext4 /dev/sda1
    mount /dev/sda1 /mnt

    cd /tmp
    curl -L https://git.io/fAldf > base
    bash base

    arch-chroot /mnt
    cd /tmp
    curl -L https://git.io/fAlQf > chroot
    bash chroot

    exit
    reboot

    # Login as oliver

    sudo systemctl start dhcpcd.service
    cd /tmp
    git clone https://github.com/ow97/arch
    cd arch
    bash setup
