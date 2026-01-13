#!/bin/bash
set -e

# =========================
# KONFIGURASI
# =========================
PHP_VERSION="8.4"


# =========================
# INSTALL PHP
# =========================
echo "Memulai instalasi PHP versi $PHP_VERSION..."
echo "----------------------------------------"

# Add the ondrej/php repository.
sudo apt update
sudo apt install -y software-properties-common
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo apt update

# Install PHP.
sudo apt install -y php$PHP_VERSION

# =========================
# VALIDASI VERSI PHP
# =========================
INSTALLED_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')

if [ "$INSTALLED_VERSION" != "$PHP_VERSION" ]; then
  echo " Versi PHP tidak sesuai!"
  echo "   Diharapkan : $PHP_VERSION"
  echo "   Terpasang  : $INSTALLED_VERSION"
  exit 1
fi

echo " PHP versi $INSTALLED_VERSION berhasil diinstall"

# =========================
# INSTALL COMPOSER
# =========================
echo "Menginstall Composer..."

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

