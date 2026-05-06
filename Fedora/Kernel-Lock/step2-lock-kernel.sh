#!/bin/bash

# Pastikan script berhenti jika ada error
set -e

# Cek apakah dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan script ini sebagai root (sudo ./step2-lock-kernel.sh)"
  exit 1
fi

echo "======================================="
echo "  Step 2: Lock Kernel Update Fedora"
echo "======================================="

echo "[*] Kernel saat ini: $(uname -r)"
echo ""

# Cek apakah dnf-plugins-core sudah terinstall
if ! dnf list installed dnf-plugins-core &> /dev/null; then
    echo "[!] dnf-plugins-core belum terinstall. Menginstall sekarang..."
    dnf install -y dnf-plugins-core
fi

# Install kernel-devel dan kernel-headers untuk kernel yang sedang berjalan
echo "[*] Memastikan kernel-devel dan kernel-headers untuk kernel aktif terinstall..."
dnf install -y \
    kernel-devel-$(uname -r) \
    kernel-headers-$(uname -r)

echo ""
echo "[*] Mengunci kernel agar tidak terupdate..."

# Lock kernel packages
dnf versionlock add kernel kernel-core kernel-modules kernel-modules-extra

echo ""
echo "[*] Daftar kernel yang terkunci:"
dnf versionlock list

echo ""
echo "======================================="
echo "  Lock Kernel Berhasil!"
echo "======================================="
echo ""
echo "[✓] Kernel $(uname -r) telah dikunci dan tidak akan terupdate."
echo "[i] Untuk membuka kunci, jalankan: sudo ./unlock-kernel-update.sh"
