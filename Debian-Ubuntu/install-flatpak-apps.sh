#!/bin/bash
set -e

# =========================
# INSTALL APLIKASI FLATPAK DEBIAN/UBUNTU
# =========================


# =========================
# SETUP FLATPAK (JIKA BELUM ADA)
# =========================
echo "=== Pastikan Flatpak terpasang ==="
if ! command -v flatpak &> /dev/null; then
  echo "Flatpak belum terpasang, menginstall..."
  sudo apt update
  sudo apt install -y flatpak
fi

echo "=== Pastikan Flathub aktif ==="
if ! flatpak remote-list | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi


# =========================
# INSTALL APLIKASI FLATPAK BANYAK SEKLIGUS
# =========================
echo "=== Install aplikasi Flatpak ==="
flatpak install -y flathub \
  com.mikrotik.WinBox \
  io.github.jonmagon.kdiskmark \
  xyz.safeworlds.hiit \
  md.obsidian.Obsidian \
  com.obsproject.Studio \
  io.missioncenter.MissionCenter \
  io.gitlab.theevilskeleton.Upscaler \
  io.github.swordpuffin.rewaita \
  org.audacityteam.Audacity \
  it.mijorus.gearlever \
  org.telegram.desktop

echo "======================================"
echo "  Instalasi Flatpak selesai           "
echo "  Aplikasi tersedia di menu aplikasi  "
echo "  Restart jika aplikasi belum muncul  "
echo "======================================"

