#!/bin/bash

# Pastikan script berhenti jika ada error
set -e

# Cek apakah dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan script ini sebagai root (sudo ./unlock-kernel-update.sh)"
  exit 1
fi

echo "======================================="
echo "   Unlock Kernel Update Fedora"
echo "======================================="

echo ""
echo " list lock kernel "
echo ""
sudo dnf versionlock list


sudo dnf versionlock clear

echo ""
echo " list lock kernel "
echo ""
sudo dnf versionlock list

echo ""
echo "======================================="
echo "  Unlock Kernel Update Fedora Berhasil "
echo "======================================="