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
        header " Instalasi Flatpak "

    # CEK APAKAH SUDAH TERINSTALL
    if command -v flatpak >/dev/null 2>&1; then
        echo " Flatpak sudah terinstall di sistem."
        echo ""
        flatpak --version
        echo ""
        pause
        return
    fi

    echo " Memulai instalasi Flatpak..."
    countsleep 2

    # UPDATE SISTEM
    echo " Update daftar paket..."
    sudo apt update

    # INSTALL FLATPAK
    echo " Menginstall Flatpak..."
    sudo apt install -y flatpak

    # OPTIONAL: PLUGIN GNOME
    echo " Menginstall GNOME plugin (opsional)..."
    sudo apt install -y gnome-software-plugin-flatpak || true

    # ADD FLATHUB
    echo " Menambahkan repository Flathub..."
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    # VERIFIKASI
    echo ""
    echo " Verifikasi instalasi:"
    flatpak --version
    flatpak remote-list

    echo ""
    echo " Instalasi selesai."
    echo " Disarankan logout / restart."

    pause
}

remove () {
    header " Remove / Uninstall Flatpak "
    if ! command -v flatpak >/dev/null 2>&1; then
        echo " Flatpak belum terinstall."
        pause
        return
    fi

    echo " Menghapus Flatpak..."
    sudo apt remove --purge -y flatpak gnome-software-plugin-flatpak || true
    sudo apt autoremove -y
    sudo apt autoclean

    echo " Flatpak berhasil dihapus."
    pause
}

cek () {
    header " Cek Flatpak "

    if command -v flatpak >/dev/null 2>&1; then
        echo " Flatpak TERPASANG"
        echo ""
        echo " Versi : $(flatpak --version) "
        echo ""
        echo " Remote: "
        flatpak remote-list
    else
        echo " Flatpak BELUM terpasang"
    fi
    pause 
}



# ===================== Menu =========================
clear
header " Flatpak Installer "
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



