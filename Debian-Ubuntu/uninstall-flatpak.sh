#!/bin/bash
set -e

echo "Memulai proses uninstall Flatpak..."
echo "----------------------------------------"

# =========================
# UNINSTALL SEMUA APLIKASI FLATPAK
# =========================
if flatpak list --app >/dev/null 2>&1; then
  echo "Menghapus semua aplikasi Flatpak..."
  flatpak uninstall -y --all
else
  echo "Tidak ada aplikasi Flatpak yang terpasang"
fi

# =========================
# HAPUS REMOTE FLATHUB
# =========================
if flatpak remote-list | grep -q flathub; then
  echo "Menghapus repository Flathub..."
  sudo flatpak remote-delete flathub
fi

# =========================
# BERSIHKAN RUNTIME & CACHE
# =========================
echo "Membersihkan runtime & cache Flatpak..."
flatpak uninstall -y --unused
rm -rf ~/.var/app
rm -rf ~/.local/share/flatpak

# =========================
# HAPUS PAKET FLATPAK
# =========================
echo "Menghapus paket Flatpak dari sistem..."
sudo apt remove --purge -y flatpak gnome-software-plugin-flatpak

# =========================
# CLEAN SYSTEM
# =========================
sudo apt autoremove -y
sudo apt autoclean

echo "----------------------------------------"
echo "Flatpak berhasil dihapus sepenuhnya"

