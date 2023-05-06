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

echo "Creating Swap Partition"
parted /dev/nvme0n1 -- mkpart primary linux-swap 512MB 18GB

echo "Creating Main Partition"
parted /dev/nvme0n1 -- mkpart primary 18GB 100%

echo "Formatting Boot Partition"
mkfs.fat -F 32 -n boot /dev/nvme0n1p1

echo "Formatting Swap Partition"
mkswap -L swap /dev/nvme0n1p2

#-------------------------------------------
echo "Creating LVM for user partitions"
pvcreate /dev/nvme0n1p3
vgcreate pool /dev/nvme0n1p3

lvcreate -L 50G -n nix-store pool
lvcreate -L 180G -n root-que pool
lvcreate -L 180G -n root-xin pool
lvcreate -l 100%FREE -n root-guest pool

echo "Encrypting Logical Volumes"
echo -e "Create password for root-que"
cryptsetup luksFormat /dev/pool/root-que
echo -e "Create password for root-xin"
cryptsetup luksFormat /dev/pool/root-xin
echo -e "Create password for root-guest"
echo "Use Guest Pin for Password"
cryptsetup luksFormat /dev/pool/root-guest
echo -e "Add Que password to Nix-store"
cryptsetup luksFormat /dev/pool/nix-store
echo -e "Add Xin password to Nix-store"
cryptsetup luksAddKey /dev/pool/nix-store
echo -e "Add Guest password to Nix-store"
echo "Use Guest Pin for Password"
cryptsetup luksAddKey /dev/pool/nix-store

echo "Open Encrypted Volumes"
echo -e "Enter password for root-que"
cryptsetup luksOpen /dev/pool/root-que crypto-que
echo -e "Enter password for root-xin"
cryptsetup luksOpen /dev/pool/root-xin crypto-xin
echo -e "Enter password for root-guest"
cryptsetup luksOpen /dev/pool/root-guest crypto-guest
echo -e "Enter password for nix-store"
cryptsetup luksOpen /dev/pool/nix-store nix-store

echo "Formatting Root Partitions"
mkfs.ext4 /dev/mapper/crypto-que
mkfs.ext4 /dev/mapper/crypto-xin
mkfs.ext4 /dev/mapper/crypto-guest
mkfs.ext4 /dev/mapper/nix-store

echo "Activating Swap"
swapon /dev/nvme0n1p2

echo -e "Run vortex-install.sh for each user"
