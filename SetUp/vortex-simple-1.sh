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
mkfs.fat -F 32 -n boot /dev/sda3

echo "Creating SWAP Partition"
parted /dev/nvme0n1 -- mkpart linux-swap 512MB 18GB
mkswap -L swap /dev/nvme0n1p2
swapon /dev/nvme0n1/by-label/swap

echo "Creating Primary Partition and Volumes"
parted /dev/nvme0n1 -- mkpart primary 18GB 100%
pvcreate /dev/nvme0n1p3
vgcreate pool /dev/nvme0n1p3

echo "Creating Logical Volumes"
lvcreate -qL 150G -n pool-que pool
lvcreate -qL 150G -n pool-xin pool
lvcreate -qL 100G -n pool-guest pool
lvcreate -ql 100%FREE -n pool-nix-store pool

echo "Encrypting Logical Volumes"
echo "!!REMEMBER TO CHECK CAPS AND NUMBER LOCK!!"
echo "Encrypt que Volume"
cryptsetup -qy luksFormat /dev/pool/pool-que
echo "Encrypt xin Volume"
cryptsetup -qy luksFormat /dev/pool/pool-xin
echo "Encrypt guest Volume"
cryptsetup -qy luksFormat /dev/pool/pool-guest
echo "Encrypt nix-store Volume, use guest Password"
cryptsetup -qy luksFormat /dev/pool/pool-nix-store

echo "Adding additional keys to nix-store Volume"
echo "Add que User Password"
cryptsetup luksAddKey /dev/pool/pool-nix-store
echo "Add xin User Password"
cryptsetup luksAddKey /dev/pool/pool-nix-store

echo "Configuring nix-store Volume, use any password"
cryptsetup luksOpen /dev/pool/pool-nix-store pool-nix-store
mkfs.btrfs -L nix-store /dev/mapper/pool-nix-store

echo "System Partitions configured. Please run vortex-init-2.sh for each user specialization."
