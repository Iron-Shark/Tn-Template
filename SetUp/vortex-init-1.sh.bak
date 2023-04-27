#!/bin/bash

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
swapon /dev/nvme0n1/by-label/swap

printf "Creating Primary Partition and Volumes"
parted /dev/nvme0n1 -- mkpart primary 18GB 100%
pvcreate -ff /dev/nvme0n1p3
vgcreate pool /dev/nvme0n1p3

printf "Creating Logical Volumes"
lvcreate -qL 150G -n pool-que pool
lvcreate -qL 150G -n pool-xin pool
lvcreate -qL 100G -n pool-guest pool
lvcreate -ql 100%FREE -n pool-nix-store pool

echo "Encrypting Logical Volumes"
echo "!!REMEMBER TO CHECK CAPS AND NUMBER LOCK!!"
printf "\nEncrypt que Volume"
cryptsetup -qy luksFormat /dev/pool/pool-que
printf "\nEncrypt xin Volume"
cryptsetup -qy luksFormat /dev/pool/pool-xin
printf "\nEncrypt guest Volume"
cryptsetup -qy luksFormat /dev/pool/pool-guest
printf "\nEncrypt nix-store Volume, use guest Password"
cryptsetup -qy luksFormat /dev/pool/pool-nix-store

printf "Adding additional keys to nix-store Volume"
printf "\nAdd que User Password"
cryptsetup luksAddKey /dev/pool/pool-nix-store
printf "\nAdd xin User Password"
cryptsetup luksAddKey /dev/pool/pool-nix-store

printf "\nConfiguring nix-store Volume, use any password"
cryptsetup luksOpen /dev/pool/pool-nix-store nix-store
mkfs.btrfs -L nix-store /dev/mapper/nix-store

bash ./vortex-init-2.sh
