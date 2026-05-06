#!/bin/bash
set -e
# =========================
# UNINSTALL LIBREOFFICE DEBIAN/UBUNTU
# =========================
echo "Memulai proses uninstall LibreOffice..."
echo "----------------------------------------"

# Hentikan proses LibreOffice jika masih berjalan
pkill -f libreoffice || true

# Hapus semua paket LibreOffice
sudo apt remove --purge -y libreoffice*

# Hapus dependensi yang tidak terpakai
sudo apt autoremove -y
sudo apt autoclean

# Hapus konfigurasi user (opsional tapi bersih)
rm -rf ~/.config/libreoffice
rm -rf ~/.cache/libreoffice
rm -rf ~/.local/share/libreoffice

echo "----------------------------------------"
echo " LibreOffice berhasil dihapus sepenuhnya"

