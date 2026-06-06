#!/bin/bash
set -e

# =========================
# UTILITIES
# =========================
log() {
  echo "▶ $1"
}

# cek paket pernah terinstall (ii / rc)
package_exists() {
  dpkg-query -W -f='${Status}\n' "$1" 2>/dev/null \
    | grep -qE "install|config"
}

# uninstall bersih satu paket
purge_package() {
  local package="$1"
  local label="$2"

  if package_exists "$package"; then
    log "Menghapus $label..."
    sudo apt purge -y "$package"
  else
    log "$label tidak ditemukan, lewati"
  fi
}

# =========================
# START
# =========================
log "Memulai uninstall aplikasi (clean & rapi)"
log "----------------------------------------"

# =========================
# THUNDERBIRD
# =========================
purge_package thunderbird "Thunderbird"

# =========================
# FIREFOX
# =========================
purge_package firefox "Mozilla Firefox"

# =========================
# LIBREOFFICE (MULTI PACKAGE)
# =========================
if dpkg -l | grep -q "^ii.*libreoffice"; then
  log "Menghapus LibreOffice (semua paket)..."
  sudo apt purge -y libreoffice*
else
  log "LibreOffice tidak ditemukan, lewati"
fi

# =========================
# BERSIHKAN SISA CONFIG (rc)
# =========================
log "Membersihkan sisa konfigurasi dpkg (rc)..."
sudo dpkg -l \
  | awk '/^rc/ {print $2}' \
  | xargs -r sudo dpkg --purge

# =========================
# AUTOREMOVE & CLEAN
# =========================
log "Membersihkan dependensi sisa..."
sudo apt autoremove -y
sudo apt autoclean

# =========================
# USER CONFIG CLEANUP
# =========================
log "Menghapus konfigurasi user..."
rm -rf ~/.mozilla \
       ~/.thunderbird \
       ~/.config/libreoffice \
       ~/.cache/libreoffice \
       ~/.local/share/libreoffice

log "----------------------------------------"
log "✅ Uninstall selesai — sistem bersih & rapi"

