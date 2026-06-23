#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

# Define Prometheus version
PROMETHEUS_VERSION="2.51.2"

echo "===================================="
echo "Starting Prometheus Installation"
echo "===================================="

# 1. Update system and install necessary packages
echo "[1/7] Updating system and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y wget tar

# 2. Create Prometheus user
echo "[2/7] Creating Prometheus service user..."
# Ignore error if user already exists
if ! id -u prometheus > /dev/null 2>&1; then
    sudo useradd --no-create-home --shell /bin/false prometheus
fi

# 3. Create correct directories
echo "[3/7] Creating configuration and data directories..."
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# 4. Download and extract Prometheus
echo "[4/7] Downloading Prometheus v${PROMETHEUS_VERSION}..."
cd /tmp
rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64* # Clean previous attempts
wget -q https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

# 5. Distribute files to their proper Linux paths
echo "[5/7] Moving binaries and configuration files..."
cd prometheus-${PROMETHEUS_VERSION}.linux-amd64

# Move binaries to standard bin path
sudo cp prometheus promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

# Move config and templates to /etc
sudo cp -r consoles console_libraries prometheus.yml /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus

# Set ownership of the data directory
sudo chown -R prometheus:prometheus /var/lib/prometheus

# 6. Create Prometheus systemd service
echo "[6/7] Creating systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service > /dev/null
[Unit]
Description=Prometheus Monitoring System
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries

Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# 7. Clean up and Start
echo "[7/7] Cleaning up and starting service..."
cd /tmp
rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64*

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Verify installation
if sudo systemctl is-active --quiet prometheus; then
    echo "===================================="
    echo "Prometheus Installed Successfully!"
    echo "===================================="
    echo "Access Prometheus at: http://$(hostname -I | awk '{print $1}'):9090"
else
    echo "Prometheus installation failed to start."
    sudo systemctl status prometheus --no-pager
    exit 1
fi
