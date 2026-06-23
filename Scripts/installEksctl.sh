#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

echo "===================================="
echo "Starting eksctl Installation"
echo "===================================="

# 1. Ensure curl and tar are installed
echo "[1/3] Checking dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl tar gzip

# 2. Download and extract eksctl
echo "[2/3] Downloading and extracting eksctl..."
# Safely remove any failed previous downloads
rm -f /tmp/eksctl 
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

# 3. Move to binary path and make executable
echo "[3/3] Installing eksctl..."
sudo mv /tmp/eksctl /usr/local/bin/eksctl
sudo chmod +x /usr/local/bin/eksctl

# Verify installation
echo "===================================="
echo "eksctl Installed Successfully!"
echo "===================================="
eksctl version
