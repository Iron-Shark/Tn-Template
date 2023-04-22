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
mkfs.btrfs /dev/pool/crypto-$userName
mkdir /tmp/root/
mount /dev/pool/crypto-$userName -o compress-force=zstd,noatime,ssd /tmp/root/
mkdir /tmp/nix
mount /dev/pool/nix-store -o compress-force=zstd,noatime,ssd /tmp/nix

echo "Creating Root Sub-volumes for user $userName"
cd /tmp/root
btrfs subvolume create home
btrfs subvolume create persist
btrfs subvolume create nixos-config

echo "Create and mount NixOS Sub-directories for user $userName"
mount -t tmpfs none /mnt
mkdir /mnt/{boot,home,persist}
mkdir /mnt/etc/nixos
mount /dev/pool/root /mnt/boot
mount /dev/pool/root -o compress-force=zstd,noatime,ssd,subvol=home /mnt/home
mount /dev/pool/root -o compress-force=zstd,noatime,ssd,subvol=persist /mnt/persist
mount /dev/pool/root -o compress-force=zstd,noatime,ssd,subvol=nixos-config /mnt/etc/nixos
mount /dev/pool/nix-store -o compress-force=zstd,noatime,ssd,subvol=nix /mnt/nix

echo "Creating hardware-configuration.nix file"
nixos-generate-config --root /mnt

echo "Manually configure system, user, and hardware files for $userName specialization"
echo "After that run 'nixos-install', and then run this script again, while specifying the next user"
echo "If all users have been configured. 'reboot' system"
