#!/bin/bash

set -e

# =========================
# INSTALL GNOME DESKTOP DEBIAN 13
# =========================
echo "======================================="
echo " Instalasi GNOME Desktop Debian 13 "
echo "======================================="

# Pastikan dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Jalankan script ini sebagai root (sudo)"
  exit 1
fi

echo "[1/5] Update repository..."
apt update

echo "[2/5] Upgrade paket sistem..."
apt upgrade -y

echo "[3/5] Install GNOME Desktop lengkap..."
apt install -y task-gnome-desktop gdm3 dbus-x11

echo "[4/5] Set display manager ke GDM3..."
echo "gdm3" > /etc/X11/default-display-manager
dpkg-reconfigure gdm3

echo "[5/5] Membersihkan paket tidak terpakai..."
apt autoremove -y
apt autoclean -y

echo "======================================="
echo " Instalasi GNOME selesai "
echo " Silakan reboot sistem"
echo "======================================="
