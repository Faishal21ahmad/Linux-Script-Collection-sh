#!/bin/bash
set -e

# =========================
# KONFIGURASI
# =========================
NVM_VERSION="v0.40.3"
NODE_MAJOR="24"
NODE_FULL_VERSION="24.8.0"

echo "Memulai instalasi Node.js via NVM..."
echo "----------------------------------------"

# =========================
# DEPENDENSI DASAR
# =========================
sudo apt update
sudo apt install -y \
  curl \
  ca-certificates \
  git

# =========================
# INSTALL NVM
# =========================
if [ ! -d "$HOME/.nvm" ]; then
  echo "Menginstall NVM $NVM_VERSION..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
else
  echo "NVM sudah terpasang"
fi

# =========================
# LOAD NVM (WAJIB DI SCRIPT)
# =========================
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# =========================
# INSTALL NODE.JS
# =========================
echo "Menginstall Node.js $NODE_MAJOR..."
nvm install $NODE_MAJOR

echo "Menggunakan Node.js $NODE_FULL_VERSION..."
nvm use $NODE_FULL_VERSION
nvm alias default $NODE_FULL_VERSION

# =========================
# VALIDASI NODE VERSION
# =========================
INSTALLED_NODE=$(node -v | sed 's/v//')

if [ "$INSTALLED_NODE" != "$NODE_FULL_VERSION" ]; then
  echo "   Versi Node.js tidak sesuai!"
  echo "   Diharapkan : $NODE_FULL_VERSION"
  echo "   Terpasang  : $INSTALLED_NODE"
  exit 1
fi

echo "  Node.js $INSTALLED_NODE berhasil diinstall"

# =========================
# INSTALL PM2
# =========================
echo "Menginstall PM2..."
npm install pm2 -g

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

