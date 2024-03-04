#!/bin/bash

# Exit on error
set -e

# Set parameters
PUBLIC_IP="$1"
MASTER_NODE_NAME="$2"
ES_FAMILY="8.x"
ES_VERSION="8.8.2"


# Install tools & deps
sudo apt-get update
sudo apt-get install -y curl wget gpg apt-transport-https

# Get the PGP key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

# Write out the repo to sources
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/$ES_FAMILY/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-$ES_FAMILY.list

# Install components
sudo apt-get update && sudo apt-get install -y kibana=$ES_VERSION



# Write out the kibana.yml file
sudo mv /etc/kibana/kibana.yml /etc/kibana.yml.ORIG
sudo touch /etc/kibana/kibana.yml


sudo bash -c "cat > /etc/kibana/kibana.yml"  <<EOF
# =================== System: Kibana Server ===================
server.port: 5601
server.host: "127.0.0.1"
server.publicBaseUrl: "https://$PUBLIC_IP"
elasticsearch.hosts: [ "http://$MASTER_NODE_NAME:9200" ]
# Enables you to specify a file where Kibana stores log output.
logging:
  appenders:
    file:
      type: file
      fileName: /var/log/kibana/kibana.log
      layout:
        type: json
  root:
    appenders:
      - default
      - file
#  layout:
#    type: json
# Specifies the path where Kibana creates the process ID file.
pid.file: /run/kibana/kibana.pid
# # =================== System: Kibana Server ===================
EOF







# Change the ownership of the new kibana.yml
sudo chown root:kibana /etc/kibana/kibana.yml


# then systemctl reload, enable and start the service 
sudo systemctl daemon-reload
sudo systemctl enable kibana
sudo systemctl start kibana



# Validations:
# check status eg. tail -f /var/log/kibana/kibana.log
# check local get eg. curl http://localhost:5601 or curl http://localhost:5601/app/kibana for an HTML response