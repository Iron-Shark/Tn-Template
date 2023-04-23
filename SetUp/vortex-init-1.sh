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

echo "Creating Primary Partition and Volumes"
parted /dev/nvme0n1 -- mkpart primary 512MB 100%
pvcreate /dev/nvme0n1p2
vgcreate pool /dev/nvme0n1p2

echo "Creating Logical Volumes"
lvcreate -L 150G -n root-que pool
lvcreate -L 150G -n root-xin pool
lvcreate -L 100G -n root-guest pool
lvcreate -C -L 17G -n swap pool
lvcreate -l 100%FREE -n nix-store pool

echo "Encrypting Logical Volumes"
echo "Encrypt que Volume"
cryptsetup -q luksFormat /dev/pool/root-que
echo "Encrypt xin Volume"
cryptsetup -q luksFormat /dev/pool/root-xin
echo "Encrypt guest Volume"
cryptsetup -q luksFormat /dev/pool/root-guest
echo "Encrypt swap Volume, use guest Password"
cryptsetup -q luksFormat /dev/pool/swap
echo "Encrypt nix-store Volume, use guest Password"
cryptsetup -q luksFormat /dev/pool/nix-store

echo "Adding additional keys to shared Volumes"
echo "Add que User Password"
cryptsetup luksFormat /dev/pool/nix-store
echo "Add xin User Password"
cryptsetup luksAddKey /dev/pool/nix-store
echo "Add que User Password"
cryptsetup luksFormat /dev/pool/swap
echo "Add xin User Password"
cryptsetup luksAddKey /dev/pool/swap

echo "Configuring nix-store Volume, use any password"
cryptsetup luksOpen /dev/pool/nix-store nix-store
mkfs.btrfs /dev/pool/nix-store

echo "Configuring swap Volume, use any password"
cryptsetup luksOpen /dev/pool/swap swap
mkswap /dev/pool/swap
swapon /dev/pool/swap

echo "System Partitions configured. Please run vortex-init-2.sh for each user specialization."
