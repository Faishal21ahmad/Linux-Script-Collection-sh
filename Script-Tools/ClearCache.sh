#!/bin/bash
set -e

# ===================== Head Init Program =========================
root() {
    exec "$0"
}

header() {
    local title=$1
    echo " ============================= "
    echo " $title " 
    echo " ============================= "
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

# ===================== Core Program =========================

cek() {
    free -h
}

cacheRam () {
    sudo sync
    sudo sysctl -w vm.drop_caches=3
}

cachePkg () {
    sudo apt clean
    sudo apt autoremove
}

cacheThumbnail () {
    rm -rf ~/.cache/thumbnails/*
}

cacheUserApps () {
    rm -rf ~/.cache/*
}

cacheLog () {
    journalctl --disk-usage
}

allCache () {
    cacheRam
    cachePkg
    cacheThumbnail
    cacheUserApps
    cacheLog
}

clearTrash () {
    read -p " Delete all files in Trash? (y/n): " trs

    if [[ "$trs" == "y" || "$trs" == "Y" ]]; then
        sudo rm -rf /home/*/.local/share/Trash/files/*
        sudo rm -rf /home/*/.local/share/Trash/info/*
        echo " Trash successfully cleared."
    else
        echo " Cancelled."
    fi
}



# ===================== Menu =========================
clear
header " CleanUP Your Linux "
echo " Pilih menu: " 
echo " 1. Cek Memory Usage "
echo " 2. Clear All Cache "
echo " 3. Clear Memory Cache"
echo " 4. Clear Cache Paket"
echo " 5. Clear Cache Thumbnail"
echo " 6. Clear Cache User Apps"
echo " 7. Clear Log"
echo " 8. Clear Trash"

echo " x. Exit "
read -p " Masukkan pilihan: " pilih

clear
# ===================== Route Program =========================

if [ "$pilih" == "1" ]; then
    header " Cek Memory Usage "
    cek
    echo " "
    read -p " Back main menu ? (y/n): " bck
    if [[ "$bck" == "y" || "$bck" == "Y" ]]; then
        clear
        root
    else
        clear
        echo " Cancelled."
    fi
elif [ "$pilih" == "2" ]; then
    header " Clear All Cache "
    allCache
    loopexe
elif [ "$pilih" == "3" ]; then
    header " Clear Memory Cache "
    cacheRam
    loopexe
elif [ "$pilih" == "4" ]; then
    header " Clear Cache Paket "
    cachePkg
    loopexe
elif [ "$pilih" == "5" ]; then
    header " Clear Cache Thumbnail " 
    cacheThumbnail
    loopexe
elif [ "$pilih" == "6" ]; then
    header " Clear Cache User Apps "
    cacheUserApps
    loopexe
elif [ "$pilih" == "7" ]; then
    header " Clear Log "
    cacheUserApps
    loopexe
elif [ "$pilih" == "8" ]; then
    header " Clear Trash "
    clearTrash
    loopexe
elif [ "$pilih" == "x" ]; then
    clear 
else
    echo " Pilihan tidak valid. "
    countsleep 3
    clear
    root
fi

