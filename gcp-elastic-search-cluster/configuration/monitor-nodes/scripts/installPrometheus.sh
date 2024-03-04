#!/bin/bash

# Exit on error
# set -e

# Create the user
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus


# Get latest prometheus binary
# wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
# Or, get the latest LTS prometheus binaries
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz -O /tmp/prometheus.tgz
tar -zxvf /tmp/prometheus.tgz -C /tmp/
mv /tmp/prometheus-* /tmp/prometheus


# Copy the binary files to their destinations
sudo cp /tmp/prometheus/prometheus /usr/local/bin
sudo cp /tmp/prometheus/promtool /usr/local/bin
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Copy the console files to their destinations
sudo cp -r /tmp/prometheus/consoles /etc/prometheus
sudo cp -r /tmp/prometheus/console_libraries /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries


# Create the prometheus config file
sudo bash -c "cat > /etc/prometheus/prometheus.yml" <<EOF
global:
    scrape_interval: 6s
scrape_configs:
    - job_name: 'prometheus'
      scrape_interval: 5s
      static_configs:
        - targets: ["localhost:9090"]
EOF


# Create the prometheus service file
sudo bash -c "cat > /etc/systemd/system/prometheus.service" <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF



# Reload, enable and start
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Add the installed file
sudo touch /etc/prometheus/installed.txt

# test locally:
#  curl http://127.0.0.1:9090/graph