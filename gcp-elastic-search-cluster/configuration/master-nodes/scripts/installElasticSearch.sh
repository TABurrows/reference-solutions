#!/bin/bash


# Exit on error
set -e


# Set parameters
ES_FAMILY="8.x"
ES_VERSION="8.8.2"
ES_NODE_FQDN=$(hostname)

# Install tools & deps
sudo apt-get update
sudo apt-get install -y curl wget jq gpg apt-transport-https


# Add Elastic repo && install
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/$ES_FAMILY/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-$ES_FAMILY.list
sudo apt-get update
sudo apt-get install elasticsearch=$ES_VERSION


# Make a backup of the default config
sudo mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.ORIG


# Write out an es config file
sudo bash -c "cat > /etc/elasticsearch/elasticsearch.yml" <<EOF
# ======================== Elasticsearch Configuration =========================
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#cluster.name: my-application
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#node.name: node-1
#
# Add custom attributes to the node:
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
path.data: /var/lib/elasticsearch
#
# Path to log files:
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
bootstrap.memory_lock: true
#
# ---------------------------------- Network -----------------------------------
#
# By default Elasticsearch is only accessible on localhost. Set a different
# address here to expose this node on the network:
# network.host: 0.0.0.0
#
# By default Elasticsearch listens for HTTP traffic on the first free port it
# finds starting at 9200. Set a specific HTTP port here:
http.port: 9200
http.cors.enabled: true
http.cors.allow-origin: "*"
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when this node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#discovery.seed_hosts: ["host1", "host2"]
#
# Bootstrap the cluster using an initial set of master-eligible nodes:
#cluster.initial_master_nodes: ["node-1", "node-2"]
# Needs the fully qualified internal domain name
cluster.initial_master_nodes: ["$ES_NODE_FQDN"]
#
# ---------------------------------- Various -----------------------------------
#
# Allow wildcard deletion of indices:
#action.destructive_requires_name: false
#
# ---------------------- BEGIN SECURITY AUTO CONFIGURATION -----------------------
#
# Enable security features
xpack.security.enabled: false
xpack.security.enrollment.enabled: false
#
# Enable encryption for HTTP API client connections, such as Kibana, Logstash, and Agents
xpack.security.http.ssl:
  enabled: false
  keystore.path: certs/http.p12
#
# Enable encryption and mutual authentication between cluster nodes
xpack.security.transport.ssl:
  enabled: false
  verification_mode: certificate
  keystore.path: certs/transport.p12
  truststore.path: certs/transport.p12
#
# Allow HTTP API connections from anywhere
# Connections are encrypted and require user authentication
http.host: 0.0.0.0
#
# Allow other nodes to join the cluster from anywhere
# Connections are encrypted and mutually authenticated
transport.host: 0.0.0.0
#
#----------------------- END SECURITY AUTO CONFIGURATION -------------------------
EOF

# Set the correct ownership on the config file
sudo chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml



# Set the jre heap size: make it static and fixed size at 1/2 system RAM available
sudo bash -c 'echo "-Xms2g" > /etc/elasticsearch/jvm.options.d/jvm.options'
sudo bash -c 'echo "-Xmx2g" >> /etc/elasticsearch/jvm.options.d/jvm.options'


## System Configuration
#
# Set number of thread pools an ES user can create
sudo bash -c 'echo -e "nproc\t4096" >> /etc/security/limits.conf'
#
# Disable swap for session
sudo swapoff -a
#
# Disable swap persistently (comment out any lines in /etc/fstab that contain 'swap')
sudo sed -i.bak '/swap/s/^/#/' /etc/fstab



## Service Configuration
#
# Memory Lock for service
sudo mkdir -p /etc/systemd/system/elasticsearch.service.d/
sudo bash -c 'echo -e "[Service]\nLimitMEMLOCK=infinity" > /etc/systemd/system/elasticsearch.service.d/override.conf'
#
# Config JNA temporary directory
sudo mkdir /usr/share/elasticsearch/tmp/
sudo chmod -R a+x /usr/share/elasticsearch/tmp/
sudo chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/tmp/
sudo bash -c 'echo "Environment=ES_TMPDIR=/usr/share/elasticsearch/tmp" >> /etc/systemd/system/elasticsearch.service.d/override.conf'
#
# # Make Service Env Vars
# sudo bash -c 'echo "Environment=ES_NODE_NAME=\"$ES_NODE_NAME\"" >> /etc/systemd/system/elasticsearch.service.d/override.conf'
# sudo bash -c 'echo "Environment=ES_NODE_IP=\"$ES_NODE_IP\"" >> /etc/systemd/system/elasticsearch.service.d/override.conf'
# sudo bash -c 'echo "Environment=ES_MASTER_NAME=\"$ES_MASTER_IP\"" >> /etc/systemd/system/elasticsearch.service.d/override.conf'
# sudo bash -c 'echo "Environment=ES_MASTER_IP=\"$ES_MASTER_IP\"" >>/etc/systemd/system/elasticsearch.service.d/override.conf'


# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
sleep 45