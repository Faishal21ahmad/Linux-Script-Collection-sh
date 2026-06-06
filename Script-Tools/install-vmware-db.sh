#!/bin/bash

# Script Instalasi VMware Workstation untuk Debian/Ubuntu
# Versi adaptasi dari Fedora

set -e

# Warna output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

log_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

# Cek root
if [ "$EUID" -ne 0 ]; then
  log_error "Harap jalankan sebagai root (sudo $0)"
  exit 1
fi

log_info "Memulai persiapan instalasi VMware..."

# Update sistem
log_info "Update package list..."
apt update

# Install dependency (versi Debian/Ubuntu)
log_info "Menginstall dependency yang diperlukan..."
apt install -y \
    build-essential \
    gcc \
    make \
    perl \
    dkms \
    linux-headers-$(uname -r) \
    elfutils

# Variabel installer
DOWNLOAD_DIR="$HOME/Downloads"
INSTALLER_PATTERN="VMware-Workstation-Full-*.bundle"

# Ambil home user asli jika pakai sudo
if [ -n "$SUDO_USER" ]; then
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    DOWNLOAD_DIR="$REAL_HOME/Downloads"
fi

log_info "Mencari installer di $DOWNLOAD_DIR..."

if [ ! -d "$DOWNLOAD_DIR" ]; then
    log_error "Direktori $DOWNLOAD_DIR tidak ditemukan!"
    exit 1
fi

cd "$DOWNLOAD_DIR"

# Cari file installer
INSTALLER_FILE=$(find . -maxdepth 1 -name "$INSTALLER_PATTERN" | sort | tail -n 1)

if [ -z "$INSTALLER_FILE" ]; then
    log_warn_url="https://support.broadcom.com/group/ecx/productfiles?subFamily=VMware%20Workstation%20Pro"
    log_error "Installer VMware tidak ditemukan dengan pola $INSTALLER_PATTERN"
    echo "Silakan download terlebih dahulu di:"
    echo "$log_warn_url"
    exit 1
fi

INSTALLER_FILENAME=$(basename "$INSTALLER_FILE")

log_info "Ditemukan installer: $INSTALLER_FILENAME"

log_info "Memberikan izin eksekusi..."
chmod +x "$INSTALLER_FILENAME"

log_info "Menjalankan installer..."
./"$INSTALLER_FILENAME"

log_info "Instalasi selesai."

echo "Jika modul kernel perlu dicompile ulang, jalankan:"
echo "sudo vmware-modconfig --console --install-all"
