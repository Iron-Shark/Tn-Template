#! /etc/bash

# Ensures the entire script is run as root.
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi
