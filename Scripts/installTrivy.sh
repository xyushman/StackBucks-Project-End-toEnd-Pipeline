#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

echo "===================================="
echo "Starting Trivy Installation"
echo "===================================="

# 1. Install necessary dependencies
echo "[1/4] Installing dependencies (wget, gnupg, lsb-release)..."
sudo apt-get update -y
sudo apt-get install wget apt-transport-https gnupg lsb-release -y

# 2. Add the Trivy repository key
echo "[2/4] Adding Trivy GPG key..."
sudo mkdir -p /etc/apt/keyrings
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
sudo gpg --dearmor --yes -o /etc/apt/keyrings/trivy.gpg

# 3. Add the Trivy repository to the sources list
echo "[3/4] Adding Trivy repository..."
echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | \
sudo tee /etc/apt/sources.list.d/trivy.list > /dev/null

# 4. Update package lists and install Trivy
echo "[4/4] Installing Trivy..."
sudo apt-get update -y
sudo apt-get install trivy -y

# Verify installation
echo "===================================="
echo "Trivy Installed Successfully!"
echo "===================================="
trivy --version
