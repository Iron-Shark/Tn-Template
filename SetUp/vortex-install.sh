#!/bin/bash

echo -en "UserName: "
read -r name

echo -e "Mounting Filesystems"
mount /dev/mapper/crypto-$name /mnt
mkdir -p /mnt/etc/nixos /mnt/boot /mnt/nix
mount /dev/mapper/nix-store /mnt/nix
mkdir /mnt/nix/config
mount --bind /mnt/nix/config /mnt/etc/nixos
mount /dev/nvme0n1p1 /mnt/boot

echo -e "Generate System configuration using nixos-generate-config --root /mnt"
echo "Or run nixos-install"
