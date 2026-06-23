#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

echo "===================================="
echo "Starting Terraform Installation"
echo "===================================="

# 1. Update package list and install dependencies
echo "[1/4] Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y gnupg software-properties-common wget lsb-release

# 2. Add HashiCorp GPG key (modern standard path)
echo "[2/4] Adding HashiCorp GPG key..."
sudo mkdir -p /etc/apt/keyrings
sudo rm -f /etc/apt/keyrings/hashicorp-archive-keyring.gpg

wget -O- https://apt.releases.hashicorp.com/gpg | \
sudo gpg --dearmor --yes -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg

# 3. Add HashiCorp repository to sources list
echo "[3/4] Adding HashiCorp repository..."
echo "deb [signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

# 4. Update package lists and install Terraform
echo "[4/4] Installing Terraform..."
sudo apt-get update -y
sudo apt-get install terraform -y

# Verify installation
echo "===================================="
echo "Terraform Installed Successfully!"
echo "===================================="
terraform -version
