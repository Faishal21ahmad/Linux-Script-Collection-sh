#!/bin/bash
set -e

# ===================== Head Init Program =========================
root() {
    exec "$0"
}

line() {
  echo " ============================= "
}

header() {
    local title="$1"
    line
    echo " $title "
    line
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
    loopexe
}

remove () {
    header " Remove Diproses "
    loopexe
}

cek () {
    header " Cek Diproses "
    loopexe
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



