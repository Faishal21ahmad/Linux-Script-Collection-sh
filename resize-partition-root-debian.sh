#!/bin/bash
set -e

# =========================
# RESIZE PARTITION ROOT DEBIAN PROXMOX VE
# =========================
echo "=== Show Partition (Before) ==="
lsblk

# =========================
# Install dependency and Proses resize partition
# =========================
echo "=== Proses Resize Partition Root ==="
sudo apt update
sudo apt install cloud-guest-utils e2fsprogs -y
sudo growpart /dev/sda 1
sudo resize2fs /dev/sda1

# =========================
# Validate Resize Partition
# =========================
echo "=== Show Partition (After) ==="
df -h / /boot/efi
lsblk

