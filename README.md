# Arch Linux installation scripts

    loadkeys uk

    fdisk /dev/sda
        n
        p
        <Enter> * 3
        w
    mkfs.ext4 /dev/sda1
    mount /dev/sda1 /mnt

    cd /tmp
    curl -L https://git.io/fA4kF > base
    bash base

    # Login as oliver

    sudo systemctl start dhcpcd
    cd /tmp
    git clone https://github.com/ow97/arch
    cd arch
    sudo bash system
