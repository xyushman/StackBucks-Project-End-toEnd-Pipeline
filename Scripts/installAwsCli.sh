#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

echo "===================================="
echo "Starting AWS CLI Installation"
echo "===================================="

# 1. Update package list and install dependencies
echo "[1/4] Installing dependencies (unzip)..."
sudo apt-get update -y
sudo apt-get install unzip -y

# 2. Download and extract the installer
echo "[2/4] Downloading AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

echo "Extracting archive..."
unzip -q awscliv2.zip

# 3. Install or update AWS CLI
echo "[3/4] Running installation..."
sudo ./aws/install --update

# 4. Clean up installation files
echo "[4/4] Cleaning up temporary files..."
rm -rf awscliv2.zip aws/

# Verify installation
echo "===================================="
echo "AWS CLI Installed Successfully!"
echo "===================================="
aws --version
