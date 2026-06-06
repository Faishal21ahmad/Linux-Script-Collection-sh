#!/bin/bash
set -e

# ===================== Head Init Program =========================
# Warna untuk output
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

log_info() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

log_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

header() {
    local title="$1"
    line "$GREEN"
    echo " $title "
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


# ===================== Core Program =========================

install() {
    header " Instalasi Diproses "
    pause
}

remove () {
    header " Remove Diproses "
    pause
}

cek () {
    header " Cek Diproses "
    pause
}

# ===================== Menu =========================
clear
header " Program -------- "
echo " Pilih menu: " 
echo " 1. Install "
echo " 2. Remove / Uninstall "
echo " 3. Cek "
echo " x. Exit "
read -p " Masukkan Pilihan: " pilih
clear

# ===================== Route Program =========================

if [ "$pilih" == "1" ]; then
    install
elif [ "$pilih" == "2" ]; then
    remove
elif [ "$pilih" == "3" ]; then
    cek
elif [ "$pilih" == "x" ]; then
    clear 
else
    echo " Pilihan tidak valid. "
    countsleep 3
    clear
    root
fi



