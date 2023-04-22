#!/bin/bash

# Ensures the entire script is run as root.
sudo -i

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
echo "Create User Password for que"
cryptsetup luksFormat /dev/pool/root-que
echo "Create User Password for xin"
cryptsetup luksFormat /dev/pool/root-xin
echo "Create User Password for guest"
cryptsetup luksFormat /dev/pool/root-guest
echo "Use que User Password"
cryptsetup luksFormat /dev/pool/nix-store
echo "Use xin User Password"
cryptsetup luksAddKey /dev/pool/nix-store
echo "Use guest User Password"
cryptsetup luksAddKey /dev/pool/nix-store
echo "Use que User Password"
cryptsetup luksFormat /dev/pool/swap
echo "Use xin User Password"
cryptsetup luksAddKey /dev/pool/swap
echo "Use guest User Password"
cryptsetup luksAddKey /dev/pool/swap

echo "Configuring nix-store Volume, use any password"
cryptsetup luksOpen /dev/pool/nix-store nix-store
mkfs.btrfs /dev/pool/nix-store

echo "Configuring swap Volume, use any password"
cryptsetup luksOpen /dev/pool/swap swap
mkswap /dev/pool/swap
swapon /dev/pool/swap

echo "System Partitions configured. Please run vortex-init-2.sh for each user specialization."
