#!/bin/bash

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

echo "Creating SWAP Partition"
parted /dev/nvme0n1 -- mkpart linux-swap 512MB 18GB
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2

echo "Creating Primary Partition and Volumes"
parted /dev/nvme0n1 -- mkpart primary 18GB 100%
pvcreate /dev/nvme0n1p3
vgcreate pool /dev/nvme0n1p3

echo "Creating Logical Volumes"
lvcreate -L 150G -n root-que pool
lvcreate -L 150G -n root-xin pool
lvcreate -L 100G -n root-guest pool
lvcreate -l 100%FREE -n nix-store pool

echo "Encrypting Logical Volumes"
echo "!!REMEMBER TO CHECK CAPS AND NUMBER LOCK!!"
echo "Encrypt que Volume"
cryptsetup luksFormat /dev/pool/root-que
echo "Encrypt xin Volume"
cryptsetup luksFormat /dev/pool/root-xin
echo "Encrypt guest Volume"
cryptsetup luksFormat /dev/pool/root-guest
echo "Encrypt nix-store Volume, use guest Password"
cryptsetup luksFormat /dev/pool/nix-store

echo "Adding additional keys to nix-store Volume"
echo "Add que User Password"
cryptsetup luksAddKey /dev/pool/nix-store
echo "Add xin User Password"
cryptsetup luksAddKey /dev/pool/nix-store

echo "Configuring nix-store Volume, use any password"
cryptsetup luksOpen /dev/pool/nix-store nix-store
mkfs.btrfs /dev/mapper/nix-store

echo "System Partitions configured. Please run vortex-init-2.sh for each user specialization."
