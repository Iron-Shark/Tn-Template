#!/bin/bash

# This file is a script based solely off of the installation instructions from the NixOS manual.

# Ensures the entire script is run as root.
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Create Partition Table
parted /dev/nvme0n1 -- mklabel gpt

# Create Root Partition
parted /dev/nvme0n1 -- mkpart primary 512MB -16GB

# Create SWAP Partition
parted /dev/nvme0n1 -- mkpart primary linux-swap -16GB 100%

# Format Boot Partition
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted /dev/nvme0n1 -- set 3 esp on

# Format Main Partition
mkfs.ext4 -L nixos /dev/nvme0n1p1

# Format Swap Partition
mkswap -L swap /dev/nvme0n1p2

# Format Boot Partition
mkfs.fat -F 32 -n boot /dev/nvme0n1p3

# Mount Main File System
mount /dev/disk/by-label/nixos /mnt

# Mount Boot File System
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Activate Swap
swapon /dev/nvme0n1p2

# Generate System Configuration
nixos-generate-config --root /mnt

# Install System
nixos-install

echo "System has been installed. Reboot when ready."
