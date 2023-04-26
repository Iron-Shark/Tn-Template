#!/bin/bash

# Ensures the entire script is run as root.
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

printf "Please enter UserName of Specialization to be configured"
echo -n "UserName: "
read -r userName

printf "Creating File System, and Mounting Root for user $userName"
cryptsetup luksOpen /dev/pool/pool-$userName crypto-$userName
mkfs.btrfs -L root-$userName /dev/mapper/crypto-$userName

printf "Creating Root Sub-volumes for user $userName"
# replace this with mount /dev/disk/by-label/labelName /mnt
# not sure how it will work but might make things a bit simpler
mount -t btrfs /dev/mapper/crypto-$userName /mnt
btrfs subvolume create /mnt/etc
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
umount /mnt

printf "Mounting Sub-Volumes for $userName"
mount -t tmpfs -o mode=755 none /mnt
mkdir -p /mnt/{boot,nix,etc,var/log,root,home}
mount /dev/nvme0n1/by-label/boot /mnt/boot
mount -o subvol=etc,compress-force=zstd,noatime /dev/mapper/nix-store /mnt/nix
mount -o subvol=etc,compress-force=zstd,noatime /dev/mapper/crypto-$userName /mnt/etc
mount -o subvol=log,compress-force=zstd,noatime /dev/mapper/crypto-$userName /mnt/var/log
mount -o subvol=root,compress-force=zstd,noatime /dev/mapper/crypto-$userName /mnt/root
mount -o subvol=home,compress-force=zstd /dev/mapper/crypto-$userName /mnt/home

printf "Creating hardware-configuration.nix file"
nixos-generate-config --root /mnt

printf "Run 'nixos-install' after checking '/etc/nixos/configuration.nix'"

printf "If everything has been configured. 'reboot' system"
