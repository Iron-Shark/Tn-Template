#!/bin/bash

# This file is a script based solely off of the installation instructions from the NixOS manual.

# Ensures the entire script is run as root.
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

printf "Creating Partition Table"
parted /dev/nvme0n1 -- mklabel gpt

printf "Creating Boot Partition"
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted /dev/nvme0n1p1 -- set 1 esp on
mkfs.fat -F 32 -n boot /dev/nvme0n1p1

printf "Creating SWAP Partition"
parted /dev/nvme0n1 -- mkpart primary linux-swap 512MB 18GB
mkswap -L swap /dev/nvme0n1p2
swapon /dev/nvme0n1p2/by-label/swap

printf "Creating main System Partition"
parted /dev/nvme0n1 -- mkpart primary 18GB 100%

printf "Creating and Mounting File System"
mkfs.ext4 -L nixos /dev/nvme0n1p3
mount /dev/nvme0n1p3/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p3/by-label/boot /mnt/boot

printf "Building System Configuration"
nixos-generate-config --root /mnt

printf "Installing System"
nixos-install

printf "NixOS has been installed. Reboot when ready."
