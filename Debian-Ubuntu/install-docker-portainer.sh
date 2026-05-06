#!/bin/bash
set -e

# =========================
# KONFIGURASI
# =========================
DOCKER_MIN_VERSION="29"

echo "Memulai instalasi Docker & Portainer..."
echo "----------------------------------------"

# =========================
# DEPENDENSI DASAR
# =========================
sudo apt update
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  apt-transport-https

# =========================
# INSTALL DOCKER ENGINE
# =========================
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# =========================
# ENABLE DOCKER
# =========================
sudo systemctl enable docker
sudo systemctl start docker

# =========================
# VALIDASI DOCKER VERSION
# =========================
INSTALLED_DOCKER_VERSION=$(docker version --format '{{.Server.Version}}' | cut -d. -f1)

if [ "$INSTALLED_DOCKER_VERSION" -lt "$DOCKER_MIN_VERSION" ]; then
  echo "  Versi Docker terlalu lama!"
  echo "  Minimum : $DOCKER_MIN_VERSION"
  echo "  Terpasang: $INSTALLED_DOCKER_VERSION"
  exit 1
fi

echo " Docker versi $(docker version --format '{{.Server.Version}}') terpasang "

# =========================
# VALIDASI DOCKER COMPOSE
# =========================
docker compose version


# Ambil IP utama perangkat
SERVER_IP=$(ip route get 1 | awk '{print $7; exit}')
SERVER_PORT=9443
CONTAINER_NAME="portainer"
CONTAINER_VOLUME="portainer_data"

# =========================
# INSTALL PORTAINER
# =========================
echo "Menginstall Portainer..."

sudo docker volume create $CONTAINER_VOLUME

sudo docker run -d \
  --name=portainer \
  --restart=always \
  -p 8000:8000 \
  -p ${SERVER_PORT}:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $CONTAINER_VOLUME:/data \
  portainer/portainer-ce:latest

# =========================
# SELESAI
# =========================
echo "----------------------------------------"
echo "   Docker & Portainer berhasil diinstall"
echo "   Akses Portainer Web:"
echo "   https://${SERVER_IP}:${SERVER_PORT}"
echo "----------------------------------------"


