#!/bin/bash

# This file is a script based solely off of the installation instructions from the NixOS manual.

# Ensures the entire script is run as root.
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

echo "Creating Partition Table"
parted /dev/nvme0n1 -- mklabel gpt

echo "Creating Boot Partition"
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted /dev/nvme0n1 -- set 1 esp on

echo "Creating Swap Partition"
parted /dev/nvme0n1 -- mkpart primary linux-swap 512MB 18GB

echo "Creating Main Partition"
parted /dev/nvme0n1 -- mkpart primary 18GB 100%

echo "Formatting Boot Partition"
mkfs.fat -F 32 -n boot /dev/nvme0n1p1

echo "Formatting Swap Partition"
mkswap -L swap /dev/nvme0n1p2

echo "Formatting Main Partition"
cryptsetup --verify-passphrase -v luksFormat nvme0n1p3
cryptsetup open nvme0n1p3 crypto-root
mkfs.btrfs /dev/mapper/crypto-root

echo "Mounting Main File System"
mount -t btrfs /dev/mapper/crypto-root /mnt

echo "Creating Main File System Sub-Volumes"
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix # This may be removed latter for hard user separation.
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log

echo "Taking System Snapshot"
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
umount /mnt

echo "Mounting File System"
mount -o subvol=root,compress=zstd,noatime /dev/mapper/crypto-root /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime /dev/mapper/crypto-root /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/crypto-root /mnt/nix # if replaced by a shared nix-store partition. Remove the subvol argument

mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/crypto-root /mnt/persist

mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime /dev/mapper/crypto-root /mnt/var/log

mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "Activating Swap"
swapon /dev/nvme0n1p2

echo "Generating System Config"
nixos-generate-config --root /mnt
