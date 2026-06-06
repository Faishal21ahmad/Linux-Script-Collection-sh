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
    header " Instalasi PHP & Composer "

    PHP_VERSION="8.4"

    # =========================
    # CEK PHP
    # =========================
    if command -v php >/dev/null 2>&1; then
        CURRENT=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
        echo " PHP sudah terinstall (versi $CURRENT)"

        if command -v composer >/dev/null 2>&1; then
            echo " Composer sudah terinstall"
        else
            echo " Composer belum ada, akan dipasang..."
        fi

        pause
        return
    fi

    echo " Memulai instalasi PHP $PHP_VERSION..."
    countsleep 2

    # =========================
    # INSTALL PHP
    # =========================
    sudo apt update
    sudo apt install -y software-properties-common
    sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y || true
    sudo apt update
    sudo apt install -y php$PHP_VERSION

    # =========================
    # VALIDASI PHP
    # =========================
    INSTALLED_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')

    if [ "$INSTALLED_VERSION" != "$PHP_VERSION" ]; then
        echo " Versi PHP tidak sesuai!"
        exit 1
    fi

    echo " PHP versi $INSTALLED_VERSION berhasil diinstall"

    # =========================
    # INSTALL COMPOSER
    # =========================
    echo " Menginstall Composer..."

    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"

    php composer-setup.php
    php -r "unlink('composer-setup.php');"

    sudo mv composer.phar /usr/local/bin/composer

    # =========================
    # VERIFIKASI
    # =========================
    echo "----------------------------------------"
    echo "PHP     : $(php -v | head -n 1)"
    echo "Composer: $(composer --version)"
    echo "----------------------------------------"
    echo " Instalasi PHP $PHP_VERSION & Composer selesai"

    pause
}

remove () {
    header " Remove PHP & Composer "

    if ! command -v php >/dev/null 2>&1; then
        echo " PHP belum terinstall."
        pause
        return
    fi

    echo " Menghapus Composer..."
    sudo rm -f /usr/local/bin/composer || true

    echo " Menghapus PHP..."
    sudo apt remove -y php* || true
    sudo apt autoremove -y

    echo " PHP & Composer berhasil dihapus."
    pause
}

cek () {
    header " Cek PHP & Composer "

    echo "----------------------------------------"

    if command -v php >/dev/null 2>&1; then
        echo " PHP TERPASANG"
        echo " Versi : $(php -v | head -n 1)"
    else
        echo " PHP BELUM terpasang"
        echo " Versi : - "
    fi

    echo "----------------------------------------"

    if command -v composer >/dev/null 2>&1; then
        echo " Composer TERPASANG"
        echo " Versi : $(composer -v | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
    else
        echo " Composer BELUM terpasang"
        echo " Versi : - "
    fi

    echo "----------------------------------------"

    pause
}


# ===================== Menu =========================
clear
header " Program PHP & Composer Manager "
echo " Pilih menu: " 
echo " 1. Install PHP & Composer"
echo " 2. Remove / Uninstall"
echo " 3. Cek Status"
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