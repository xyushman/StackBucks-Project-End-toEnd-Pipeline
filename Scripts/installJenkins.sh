#!/bin/bash

set -e

echo "===================================="
echo "Starting Jenkins Installation"
echo "===================================="

# 1. Update system packages
echo "[1/7] Updating package index..."
sudo apt update -y

# 2. Install Java (required for Jenkins)
echo "[2/7] Installing Java 21..."
sudo apt install -y fontconfig openjdk-21-jre

# 3. Remove old Jenkins repo/key if exists (prevents conflicts)
echo "[3/7] Cleaning old Jenkins repo configuration..."
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /usr/share/keyrings/jenkins-keyring.gpg
sudo rm -f /etc/apt/keyrings/jenkins.gpg

# 4. Add Jenkins GPG key (correct modern method)
echo "[4/7] Adding Jenkins repository key..."
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/jenkins.gpg

# 5. Add Jenkins repository
echo "[5/7] Adding Jenkins repository..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# 6. Update package index again
echo "[6/7] Updating package index with Jenkins repo..."
sudo apt update -y

# 7. Install Jenkins
echo "[7/7] Installing Jenkins..."
sudo apt install -y jenkins

# Enable and start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Verify Jenkins status
if sudo systemctl is-active --quiet jenkins; then
    echo "===================================="
    echo "Jenkins Installed Successfully!"
    echo "===================================="
    echo "Access Jenkins at:"
    echo "http://$(hostname -I | awk '{print $1}'):8080"
    echo ""
    echo "Initial Admin Password:"
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Jenkins installation failed."
    sudo systemctl status jenkins --no-pager
    exit 1
fi
