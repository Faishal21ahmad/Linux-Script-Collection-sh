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
     header " Instalasi Node.js (NVM) "

    NVM_VERSION="v0.40.4"
    NODE_MAJOR="24"
    NODE_FULL_VERSION="24.15.0"

    # =========================
    # CEK NODE
    # =========================
    if command -v node >/dev/null 2>&1; then
        echo " Node.js sudah terinstall"
        echo " Versi : $(node -v)"

        if command -v pm2 >/dev/null 2>&1; then
            echo " PM2 sudah terinstall"
        else
            echo " PM2 belum ada"
        fi

        pause
        return
    fi

    echo " Memulai instalasi Node.js via NVM..."
    countsleep 2

    # =========================
    # DEPENDENSI
    # =========================
    sudo apt update
    sudo apt install -y curl ca-certificates git

    # =========================
    # INSTALL NVM
    # =========================
    if [ ! -d "$HOME/.nvm" ]; then
        echo " Menginstall NVM $NVM_VERSION..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
    else
        echo " NVM sudah terpasang"
    fi

    # =========================
    # LOAD NVM (WAJIB)
    # =========================
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # =========================
    # INSTALL NODE
    # =========================
    echo " Menginstall Node.js $NODE_MAJOR..."
    nvm install $NODE_MAJOR

    echo " Menggunakan Node.js $NODE_FULL_VERSION..."
    nvm use $NODE_FULL_VERSION
    nvm alias default $NODE_FULL_VERSION

    # =========================
    # VALIDASI
    # =========================
    INSTALLED_NODE=$(node -v | sed 's/v//')

    if [ "$INSTALLED_NODE" != "$NODE_FULL_VERSION" ]; then
        echo " Versi Node.js tidak sesuai!"
        exit 1
    fi

    echo " Node.js $INSTALLED_NODE berhasil diinstall"

    # =========================
    # INSTALL PM2
    # =========================
    echo " Menginstall PM2..."
    npm install -g pm2

    # =========================
    # VERIFIKASI
    # =========================
    echo "----------------------------------------"
    echo "Node.js : $(node --version)"
    echo "NPM     : $(npm --version)"
    echo "NPX     : $(npx --version)"
    echo "PM2     : $(pm2 --version)"
    echo "----------------------------------------"
    echo " Instalasi Node.js via NVM selesai "
    pause
}

remove () {
    header " Remove Node.js & NVM "

    # =========================
    # STOP PM2 (jika ada)
    # =========================
    if command -v pm2 >/dev/null 2>&1; then
        echo " Menghentikan PM2..."
        pm2 delete all || true
        pm2 kill || true
    fi

    # =========================
    # HAPUS NVM
    # =========================
    if [ -d "$HOME/.nvm" ]; then
        echo " Menghapus NVM..."
        rm -rf "$HOME/.nvm"
    fi

    # =========================
    # HAPUS CONFIG SHELL
    # =========================
    sed -i '/nvm.sh/d' ~/.bashrc || true
    sed -i '/nvm.sh/d' ~/.zshrc || true
    sed -i '/NVM_DIR/d' ~/.bashrc || true
    sed -i '/NVM_DIR/d' ~/.zshrc || true

    # =========================
    # KONFIRMASI CLEAN CACHE
    # =========================
    echo ""
    read -p " Hapus cache & config npm juga? (y/n): " confirm

    case "$confirm" in
        y|Y)
            echo " Membersihkan cache npm..."
            rm -rf ~/.npm || true
            rm -rf ~/.config/npm || true
            ;;
        *)
            echo " Lewati penghapusan cache."
            ;;
    esac

    echo ""
    echo " Node.js, NVM, dan environment terkait berhasil dihapus."
    pause
}

cek () {
    header " Cek Node.js & NVM "

    if command -v node >/dev/null 2>&1; then
        echo " Node.js TERPASANG"
        echo " Versi : $(node -v)"
    else
        echo " Node.js BELUM terpasang"
    fi

    echo ""

    if command -v npm >/dev/null 2>&1; then
        echo " NPM TERPASANG"
        echo " Versi : $(npm -v)"
    else
        echo " NPM BELUM terpasang"
    fi

    echo ""

    if command -v npx >/dev/null 2>&1; then
        echo " NPX TERPASANG"
        echo " Versi : $(npx --version)"
    else
        echo " NPX BELUM terpasang"
    fi

    echo ""

    if [ -d "$HOME/.nvm" ]; then
        echo " NVM TERPASANG"

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        echo " Versi NVM : $(nvm --version)"
    else
        echo " NVM BELUM terpasang"
    fi

    echo ""

    if command -v pm2 >/dev/null 2>&1; then
        echo " PM2 TERPASANG"
        echo " Versi : $(pm2 --version)"
    else
        echo " PM2 BELUM terpasang"
    fi

    pause
}

# ===================== Menu =========================
clear
header " Program Node.js Manager "
echo " Pilih menu: " 
echo " 1. Install Node.js (NVM)"
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



