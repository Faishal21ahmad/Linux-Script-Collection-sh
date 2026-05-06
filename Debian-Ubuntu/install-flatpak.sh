#!/bin/bash
set -e

echo "Memulai instalasi Flatpak (Official Guide)..."
echo "----------------------------------------"

# =========================
# UPDATE SISTEM
# =========================
echo "Update daftar paket..."
sudo apt update

# =========================
# INSTALL FLATPAK
# =========================
echo "Menginstall Flatpak..."
sudo apt install -y flatpak

# =========================
# OPTIONAL: PLUGIN GNOME SOFTWARE
# =========================
echo "Menginstall GNOME Software plugin (opsional)..."
sudo apt install -y gnome-software-plugin-flatpak

# =========================
# ADD REPOSITORY FLATHUB
# =========================
echo "Menambahkan repository Flathub (tempat aplikasi Flatpak)..."
# If already added, this will not duplicate
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# =========================
# VERIFIKASI
# =========================
echo "----------------------------------------"
echo "Versi Flatpak:"
flatpak --version

echo ""
echo "Daftar remote Flatpak:"
flatpak remote-list

echo "----------------------------------------"
echo "Flatpak telah terpasang!"
echo "Restart atau logout/login ulang untuk menyelesaikan setup."

