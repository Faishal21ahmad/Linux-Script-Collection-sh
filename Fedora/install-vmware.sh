#!/bin/bash

# Script Instalasi VMware Workstation untuk Fedora
# Dibuat agar lebih rapih dan aman

# Pastikan script berhenti jika ada error
set -e

# Warna untuk output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

log_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

# Cek apakah dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  log_error "Harap jalankan script ini sebagai root (sudo $0)"
  exit 1
fi

log_info "Memulai proses persiapan instalasi VMware..."

# Update sistem dan install dependency untuk Fedora
log_info "Menginstall dependency yang diperlukan (gcc, make, kernel-headers, dll)..."
# Menggunakan dnf bukan apt karena ini folder Fedora
dnf install -y \
    gcc \
    make \
    perl \
    kernel-devel \
    kernel-headers \
    elfutils-libelf-devel \
    dkms

# Variabel untuk file installer
DOWNLOAD_DIR="$HOME/Downloads"
INSTALLER_PATTERN="VMware-Workstation-Full-*.bundle"

# Pindah ke direktori Downloads user asli (jika dijalankan dengan sudo, $HOME mungkin root, jadi kita coba cari user asli jika ada)
# Namun, script aslinya hardcode cd ~/Downloads. Mari kita perbaiki agar mencari di home user yang memanggil sudo jika ada.
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

# Cek keberadaan file installer
INSTALLER_FILE=$(find . -maxdepth 1 -name "$INSTALLER_PATTERN" | sort | tail -n 1)

if [ -z "$INSTALLER_FILE" ]; then
    log_warn_url="https://support.broadcom.com/group/ecx/productfiles?subFamily=VMware%20Workstation%20Pro&displayGroup=VMware%20Workstation%20Pro%2025H2%20for%20Linux&release=25H2&os=&servicePk=&language=EN&freeDownloads=true"
    log_error "Installer VMware tidak ditemukan dengan pola $INSTALLER_PATTERN"
    echo "Silakan download terlebih dahulu di:"
    echo "$log_warn_url"
    exit 1
fi

# Hapus ./ dari nama file untuk tampilan yang lebih bersih
INSTALLER_FILENAME=$(basename "$INSTALLER_FILE")

log_info "Ditemukan installer: $INSTALLER_FILENAME"
log_info "Memberikan izin eksekusi..."
chmod +x "$INSTALLER_FILENAME"

log_info "Menjalankan installer..."
./"$INSTALLER_FILENAME"

log_info "Instalasi selesai. Jika modul kernel perlu dicompile ulang, jalankan:"
echo "sudo vmware-modconfig --console --install-all"
