#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

echo "===================================="
echo "Starting Docker Installation"
echo "===================================="

# 1. Update the package list
echo "[1/5] Updating package index..."
sudo apt-get update -y

# 2. Install Docker
echo "[2/5] Installing Docker..."
sudo apt-get install docker.io -y

# 3. Configure User Permissions
echo "[3/5] Adding users to the 'docker' group..."
sudo usermod -aG docker ubuntu 
sudo usermod -aG docker jenkins

# 4. Set Socket Permissions & Restart
echo "[4/5] Configuring socket permissions and restarting service..."
sudo chmod 660 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock
sudo systemctl restart docker

# 5. Verify installation
echo "[5/5] Verifying installation..."
docker --version

echo "===================================="
echo "Docker Installed Successfully!"
echo "===================================="

