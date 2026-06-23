#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

echo "===================================="
echo "Starting Grafana Installation"
echo "===================================="

# 1. Update package list and install dependencies
echo "[1/5] Updating package index and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https software-properties-common wget

# 2. Add Grafana's GPG key safely
echo "[2/5] Adding Grafana GPG key..."
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | \
sudo gpg --dearmor --yes -o /etc/apt/keyrings/grafana.gpg

# 3. Add Grafana repository (Overwrite, do not append)
echo "[3/5] Adding Grafana repository..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | \
sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null

# 4. Update package lists and install Grafana
echo "[4/5] Installing Grafana..."
sudo apt-get update -y
sudo apt-get install grafana -y

# 5. Start and enable Grafana service
echo "[5/5] Starting Grafana service..."
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Verify installation
if sudo systemctl is-active --quiet grafana-server; then
    echo "===================================="
    echo "Grafana Installed Successfully!"
    echo "===================================="
    echo "Access Grafana at: http://$(hostname -I | awk '{print $1}'):3000"
    echo "Default User: admin"
    echo "Default Password: admin"
else
    echo "Grafana installation failed to start."
    sudo systemctl status grafana-server --no-pager
    exit 1
fi
