#!/bin/bash

# Pastikan script berhenti jika ada error
set -e

# Cek apakah dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan script ini sebagai root (sudo ./remove-libreoffice.sh)"
  exit 1
fi

echo "======================================="
echo "   Menghapus LibreOffice di Fedora"
echo "======================================="

echo "[*] Daftar paket LibreOffice yang terinstall:"
rpm -qa | grep libreoffice || echo "Tidak ada paket libreoffice via RPM yang ditemukan."

echo ""
echo "[*] Memulai proses penghapusan via DNF..."
# Menghapus paket libreoffice dan dependensinya
dnf remove -y libreoffice*

echo "[*] Membersihkan dependensi yang tidak terpakai (autoremove)..."
dnf autoremove -y

echo "[*] Membersihkan cache..."
dnf clean all

# Menghapus konfigurasi user
# Jika dijalankan dengan sudo, kita perlu mendapatkan home directory dari user asli
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    if [ -d "$USER_HOME" ]; then
        echo "[*] Menghapus konfigurasi LibreOffice untuk user: $SUDO_USER"
        rm -rf "$USER_HOME/.config/libreoffice"
        rm -rf "$USER_HOME/.cache/libreoffice"
    fi
else
    # Fallback jika tidak terdeteksi via sudo (misal login root langsung), coba hapus dari /home/* (opsional, tapi berisiko, lebih baik warning saja)
    echo "[!] Script dijalankan langsung sebagai root (bukan via sudo)."
    echo "    Konfigurasi di folder user (/home/username/.config/libreoffice) mungkin perlu dihapus manual."
fi

# Cek apakah ada flatpak (opsional, banyak user Fedora pakai Flatpak)
if command -v flatpak &> /dev/null; then
    if flatpak list | grep -q org.libreoffice.LibreOffice; then
        echo ""
        echo "[?] Terdeteksi LibreOffice versi Flatpak."
        read -p "Apakah Anda ingin menghapus LibreOffice versi Flatpak juga? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            flatpak uninstall -y org.libreoffice.LibreOffice
            echo "[*] LibreOffice Flatpak dihapus."
        fi
    fi
fi

echo ""
echo "======================================="
echo "   Selesai! LibreOffice telah dihapus."
echo "======================================="
