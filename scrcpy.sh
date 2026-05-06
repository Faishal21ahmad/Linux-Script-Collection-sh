#!/bin/bash
set -e
trap 'echo "Error terjadi di baris $LINENO"; exit 1' ERR

echo " Pilih menu: " 
echo " 1. Install SCRCPY dan ADB "
echo " 2. Pilihan 1 "
echo " 3. Pilihan 2 "
echo " x. Exit "
read -p " Masukkan pilihan: " pilih

# ===================== Head Program Init =========================
root() {
    ./scrcpy.sh
}


line() { echo " ============================= " 
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

try() {
    "$@"
}

catch() {
    echo "Terjadi error!"
}


# ===================== Core Program =========================

install1() {
    line
    echo " Instalasi Diproses "
    line
    loopexe
}

pilihan1 () {
    while true; do
        (
            set -e
            echo "Menjalankan..."
            "$HOME/scrcpy/scrcpy" \
                --video-source=camera \
                --window-title='Cam1' \
                --window-borderless
        ) || {
            echo "Error terjadi"
        }

        echo
        read -p "Ingin menjalankan kembali? (y/n): " konfirmasi

        case "$konfirmasi" in
            y|Y)
                echo "Mengulang..."
                clear
                ;;
            n|N)
                echo "Kembali ke menu..."
                
                clear
                ;;
            *)
                echo "Input tidak valid, kembali ke menu..."
                loopexe
                
                ;;
        esac
        loopexe
    done
}

pilihan2 () {
    line
    echo " Pilihan 2 "
    line
    loopexe
}


pilihan3 () {
    line
    echo " Pilihan 3 "
    line
    loopexe
}


clear

# ===================== Route Program =========================

if [ "$pilih" == "1" ]; then
    install1
elif [ "$pilih" == "2" ]; then
    pilihan1
elif [ "$pilih" == "3" ]; then
    pilihan2
elif [ "$pilih" == "x" ]; then
    clear 
else
    echo " Pilihan tidak valid. "
    countsleep 3
    clear
    root
fi



