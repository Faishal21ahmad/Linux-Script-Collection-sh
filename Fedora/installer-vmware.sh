#!/bin/bash
set -e

# ===================== Head Init Program =========================
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

root() {
    exec "$0"
}

line() {
    local color="${1:-$NC}"
    echo -e "${color}==============================${NC}"
    # line "$GREEN"
    # line "$RED"
    # line "$YELLOW"
}

header() {
    local title="$1"
    line "$GREEN" 
    echo -e "${GREEN} $title${NC}"
    line "$GREEN"
}

countsleep() {
    local seconds=$1

    while [ $seconds -gt 0 ]; do
        printf "\r Menunggu %02d detik..." "$seconds"
        sleep 1
        ((seconds--))
    done
}

loopexe() {
    countsleep 4
    clear
    root
}

pause() {
    echo ""
    read -p " Tekan Enter untuk kembali ke menu..."
    root
}

log_info() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

log_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}


# ===================== Core Program =========================

install() {
    header " Instalasi Diproses VMware "

    log_info "Memulai proses persiapan instalasi VMware..."

    # Update sistem dan install dependency untuk Fedora
    log_info "Menginstall dependency yang diperlukan (gcc, make, kernel-headers, dll)..."

    dnf install -y \
        gcc \
        make \
        perl \
        dkms \
        kernel-devel \
        kernel-headers \
        elfutils-libelf-devel

    # Variabel untuk file installer
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    INSTALLER_PATTERN="VMware-Workstation-Full-*.bundle"

    log_info "Mencari installer di $SCRIPT_DIR..."

    if [ ! -d "$SCRIPT_DIR" ]; then
        log_error "Direktori script tidak ditemukan!"
        exit 1
    fi

    cd "$SCRIPT_DIR"

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

    log_info " Instalasi selesai. Jika modul kernel perlu dicompile ulang, jalankan:"
    echo " $ sudo vmware-modconfig --console --install-all"
    pause
}

remove() {
    header " Remove Diproses "

    echo
    echo "Peringatan!"
    echo "Tindakan ini akan menghapus VMware Workstation dari sistem."
    echo

    read -rp "Lanjut uninstall VMware? (y/N): " confirm_uninstall

    case "$confirm_uninstall" in
        [yY]|[yY][eE][sS])
            log_info "Memulai uninstall VMware..."
            sudo vmware-installer -u vmware-workstation
            ;;
        *)
            log_info "Uninstall dibatalkan."
            pause
            return
            ;;
    esac

    echo
    echo "Penghapusan aplikasi selesai."
    echo "Data VM dan konfigurasi VMware masih tersimpan."
    echo

    read -rp "Hapus seluruh data dan konfigurasi VMware? (y/N): " confirm_data

    case "$confirm_data" in
        [yY]|[yY][eE][sS])
            log_info "Menghapus data dan konfigurasi VMware..."

            rm -rf ~/.vmware
            rm -rf ~/vmware

            sudo rm -rf /etc/vmware
            sudo rm -rf /usr/lib/vmware

            log_info "Data dan konfigurasi VMware berhasil dihapus."
            ;;
        *)
            log_info "Data VMware dipertahankan."
            ;;
    esac

    pause
}

rebuildmodul () {
    header " Rebuild Diproses "

    sudo vmware-modconfig --console --install-all

    pause
}

cek () {
    header " Info App "
    echo ""
    sudo vmware-installer -l
    pause
}

# ===================== Menu =========================
clear
header " Instalasi VMware "
echo " Pilih menu: " 
echo " 1. Install "
echo " 2. Remove / Uninstall "
echo " 3. Rebuild modul fixing "
echo " 4. Info "
echo " x. Exit "
read -p " Masukkan Pilihan: " pilih
clear

# ===================== Route Program =========================

if [ "$pilih" == "1" ]; then
    install
elif [ "$pilih" == "2" ]; then
    remove
elif [ "$pilih" == "3" ]; then
    rebuildmodul
elif [ "$pilih" == "4" ]; then
    cek
elif [ "$pilih" == "x" ]; then
    clear 
else
    echo " Pilihan tidak valid. "
    countsleep 3
    clear
    root
fi



