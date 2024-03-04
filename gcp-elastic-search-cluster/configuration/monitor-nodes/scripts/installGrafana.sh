#!/bin/bash

# Exit on error
set -e

GRAFANA_USER="$1"
GRAFANA_PASS="$2"

# Get tools and deps
sudo apt-get update && sudo apt-get install -y curl wget apt-transport-https software-properties-common
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key

# Add the repo for stable
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Updates the packages list
sudo apt-get update

# Install OSS Grafana
sudo apt-get install -y grafana

# Reset the password
sudo grafana-cli $GRAFANA_USER reset-admin-password $GRAFANA_PASS

# Reload, enable and start grafana
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server