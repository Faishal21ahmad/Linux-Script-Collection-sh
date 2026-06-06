#!/bin/bash
set -e

# =========================
# Instalasi Update system
# =========================
echo "=== Update sistem & dependency dasar ==="
sudo apt update
sudo apt install -y curl ca-certificates gnupg lsb-release

# =========================
# Tambah Official Repo (jika perlu)
# =========================
echo "=== Install atau Tambah Repo (Official Repo) ==="

sudo apt update

# =========================
# Install Aplikasi dari APT banyak sekaligus 
# =========================
echo "=== Install aplikasi dari APT ==="
sudo apt install -y \
  htop \
  nvtop \
  fastfetch \
  gnome-extension-manager \
  gnome-shell-extensions \
  gnome-tweaks

echo "============================================================="
echo " Instalasi aplikasi selesai, silakan cek di menu aplikasi"
echo " Silakan logout/login jika GNOME Extensions belum muncul"
echo "============================================================="

