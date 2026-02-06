#!/bin/bash

set -e



echo "===== STEP 1: System update ====="
sudo apt update && sudo apt upgrade -y

echo "===== STEP 2: Install dependencies ====="
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "===== STEP 3: Add Docker GPG key ====="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "===== STEP 4: Add Docker repository ====="
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "===== STEP 5: Install Docker Engine ====="
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "===== STEP 6: Start & enable Docker ====="
sudo systemctl enable docker
sudo systemctl start docker

echo "===== STEP 7: Allow Docker without sudo ====="
sudo usermod -aG docker $USER

echo "===== STEP 8 : Kubernetes / kind system tuning ====="
sudo sysctl -w fs.inotify.max_user_watches=524288
sudo sysctl -w fs.inotify.max_user_instances=512

sudo bash -c 'cat <<EOF >> /etc/sysctl.conf
fs.inotify.max_user_watches=524288
fs.inotify.max_user_instances=512
EOF'

echo "===== STEP 9: Docker info ====="
docker --version
docker compose version

echo "===== DONE ====="
echo_msg "Docker installation completed successfully!"
