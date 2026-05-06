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

DOCKER_MIN_VERSION="29"
SERVER_IP=$(ip route get 1 | awk '{print $7; exit}')
SERVER_PORT=9443
CONTAINER_NAME="portainer"
CONTAINER_VOLUME="portainer_data"


install() {
    header " Instalasi Docker & Portainer "
    

    # =========================
    # CEK DOCKER
    # =========================
    if command -v docker >/dev/null 2>&1; then
        echo " Docker sudah terinstall."
        docker --version || true
        echo ""

        # cek portainer container
        if sudo docker ps -a --format '{{.Names}}' | grep -q "^portainer$"; then
            echo " Portainer sudah terpasang."
        else
            echo " Portainer belum ada, akan dipasang..."
        fi

        pause
        return
    fi

    echo " Memulai instalasi Docker..."
    countsleep 2

    # =========================
    # DEPENDENSI
    # =========================
    sudo apt update
    sudo apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        apt-transport-https

    # =========================
    # REPO DOCKER
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

    # =========================
    # INSTALL DOCKER
    # =========================
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
    # VALIDASI VERSION
    # =========================
    INSTALLED_DOCKER_VERSION=$(docker version --format '{{.Server.Version}}' | cut -d. -f1)

    if [ "$INSTALLED_DOCKER_VERSION" -lt "$DOCKER_MIN_VERSION" ]; then
        echo " Versi Docker terlalu lama!"
        exit 1
    fi

    echo " Docker versi $(docker version --format '{{.Server.Version}}') terpasang"
    docker compose version || true

    # =========================
    # INSTALL PORTAINER
    # =========================
    echo " Menginstall Portainer..."

    sudo docker volume create $CONTAINER_VOLUME

    sudo docker run -d \
        --name=portainer \
        --restart=always \
        -p 8000:8000 \
        -p ${SERVER_PORT}:9443 \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $CONTAINER_VOLUME:/data \
        portainer/portainer-ce:latest

    echo "----------------------------------------"
    echo "   Docker & Portainer berhasil diinstall"
    echo "   Akses Portainer Web:"
    echo "   https://${SERVER_IP}:${SERVER_PORT}"
    echo "----------------------------------------"

    pause
}


remove () {
    header " Remove Docker & Portainer "
    if ! command -v docker >/dev/null 2>&1; then
        echo " Docker belum terinstall."
        pause
        return
    fi

    echo " Menghapus Portainer..."
    sudo docker rm -f $CONTAINER_NAME >/dev/null 2>&1 || true
    sudo docker volume rm $CONTAINER_VOLUME >/dev/null 2>&1 || true

    echo " Menghapus Docker..."
    sudo apt remove -y \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin || true

    sudo apt autoremove -y

    echo " Docker & Portainer berhasil dihapus."
    pause
}

cek () {
    header " Cek Docker & Portainer"
    
    if command -v docker >/dev/null 2>&1; then
        echo " Docker TERPASANG "
        echo " Versi : $(docker version --format '{{.Server.Version}}') "

        echo ""
        echo " Status service:"
        echo " Docker: $(systemctl is-active docker || echo 'tidak aktif') "

        echo ""
        echo " Status Portainer:"

        # Cek apakah container portainer ada
        if sudo docker ps -a --format '{{.Names}}' | grep -q "^portainer$"; then
            
            STATUS=$(sudo docker inspect -f '{{.State.Status}}' portainer)
            IMAGE=$(sudo docker inspect -f '{{.Config.Image}}' portainer)

            echo " Portainer TERPASANG"
            echo " Status  : $STATUS"
            echo " Image   : $IMAGE"

            # Ambil versi dari image (tag)
            VERSION=$(echo "$IMAGE" | cut -d: -f2)
            echo " Versi   : $VERSION"

            SERVER_IP=$(ip route get 1 | awk '{print $7; exit}')
            echo ""
            echo " Akses   : https://${SERVER_IP}:9443"

        else
            echo " Portainer BELUM terpasang"
        fi

    else
        echo " Docker BELUM terpasang"
    fi

    pause
}

add_user_to_docker_group () {
    sudo usermod -aG docker $USER
    newgrp docker
}



# ===================== Menu =========================
clear
header " Program Docker & Portainer Installer "
echo " Pilih menu: " 
echo " 1. Install "
echo " 2. Remove / Uninstall "
echo " 3. Cek "
echo " 4. Add User ke Docker Group "
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
elif [ "$pilih" == "4" ]; then
    add_user_to_docker_group
elif [ "$pilih" == "x" ]; then
    clear 
else
    echo " Pilihan tidak valid. "
    countsleep 3
    clear
    root
fi



