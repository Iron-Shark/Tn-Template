#!/bin/bash

# Ensures the entire script is run as root.
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

echo "Please enter UserName of Specialization to be configured"
echo -n "UserName: "
read -r userName

echo "Creating File System, and Mounting Root for user $userName"
cryptsetup luksOpen /dev/pool/root-$userName crypto-$userName
mkfs.btrfs /dev/mapper/crypto-$userName

echo "Creating Root Sub-volumes for user $userName"
mount /dev/mapper/crypto-$userName /mnt
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/etc
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
umount /mnt

echo "Mounting Sub-Volumes for $userName"
mount -t tmpfs -o mode=755 none /mnt
mkdir -p /mnt/{boot,nix,etc,var/log,root,home}
mount /dev/nvme0n1p1 /mnt/boot
mount -o subvol=nix,compress-force=zstd,noatime /dev/mapper/crypto-$userName /mnt/nix
mount -o subvol=etc,compress-force=zstd,noatime /dev/mapper/crypto-$userName /mnt/etc
mount -o subvol=log,compress-force=zstd,noatime /dev/mapper/crypto-$userName /mnt/var/log
mount -o subvol=root,compress-force=zstd,noatime /dev/mapper/crypto-$userName /mnt/root
mount -o subvol=home,compress-force=zstd /dev/mapper/crypto-$userName /mnt/home

echo "Creating hardware-configuration.nix file"
nixos-generate-config --root /mnt

echo "Manually configure system, user, and hardware files for $userName specialization"
echo "After that run 'nixos-install', and then run this script again, while specifying the next user"
echo "If all users have been configured. 'reboot' system"
