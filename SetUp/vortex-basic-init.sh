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
mkfs.fat -F 32 -n boot /dev/nvme0n1p3

echo "Formatting Swap Partition"
mkswap -L swap /dev/nvme0n1p2

echo "Formatting Main Partition"
mkfs.ext4 -L nixos /dev/nvme0n1p3

echo "Mounting Main File System"
mount /dev/disk/by-label/nixos /mnt

echo "Mounting Boot File System"
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "Activating Swap"
swapon /dev/nvme0n1p2

echo "Generating System Config"
nixos-generate-config --root /mnt

echo "Installing System"
nixos-install

echo "System has been installed. Reboot when ready."
