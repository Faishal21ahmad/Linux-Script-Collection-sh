#!/bin/bash

# Pastikan script berhenti jika ada error
set -e

# Cek apakah dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan script ini sebagai root (sudo ./step1-update-kernel.sh)"
  exit 1
fi

echo "======================================="
echo "  Step 1: Update Kernel Fedora"
echo "======================================="

echo "[*] Kernel saat ini: $(uname -r)"
echo ""

# Update semua paket termasuk kernel
echo "[*] Memperbarui sistem dan kernel ke versi terbaru..."
dnf update -y

# Install kernel development tools untuk kernel yang baru
echo ""
echo "[*] Menginstall kernel development tools..."
dnf install -y \
    gcc make git \
    kernel-devel \
    kernel-headers \
    elfutils-libelf-devel

# Install dnf-plugins-core untuk versionlock (akan digunakan di step 2)
echo ""
echo "[*] Menginstall dnf-plugins-core untuk versionlock..."
dnf install -y dnf-plugins-core

echo ""
echo "======================================="
echo "        Update Kernel Selesai!        "
echo "======================================="
echo ""
echo "[!] Sistem akan REBOOT dalam 10 detik..."
echo "[!] Setelah reboot, jalankan: sudo ./step2-lock-kernel.sh"
echo ""

# Countdown sebelum reboot
for i in {10..1}; do
    echo -ne "\rReboot dalam $i detik... (Ctrl+C untuk membatalkan)"
    sleep 1
done

echo ""
echo "[*] Melakukan reboot sekarang..."
reboot
