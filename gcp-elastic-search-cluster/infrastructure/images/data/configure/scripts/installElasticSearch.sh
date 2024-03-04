#!/bin/bash


# Exit on error
set -e


# Set parameters
ES_FAMILY="8.x"
ES_VERSION="8.8.2"
ES_NODE_FQDN=$(hostname)
ES_DISCOVERY_SEED_HOSTS="$1"

# Install tools & deps
sudo apt-get update
sudo apt-get install -y curl wget gpg apt-transport-https


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
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
#cluster.name: my-application
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
#node.name: node-1
#
# Add custom attributes to the node:
#
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /var/lib/elasticsearch
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: false
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# By default Elasticsearch is only accessible on localhost. Set a different
# address here to expose this node on the network:
#
#network.host: 192.168.0.1
#
# By default Elasticsearch listens for HTTP traffic on the first free port it
# finds starting at 9200. Set a specific HTTP port here:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when this node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.seed_hosts: [$ES_DISCOVERY_SEED_HOSTS]
  
  #
# Bootstrap the cluster using an initial set of master-eligible nodes:
#
#cluster.initial_master_nodes: ["node-1", "node-2"]
#
# For more information, consult the discovery and cluster formation module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Allow wildcard deletion of indices:
#
#action.destructive_requires_name: false

#----------------------- BEGIN SECURITY AUTO CONFIGURATION -----------------------
#
# The following settings, TLS certificates, and keys have been automatically      
# generated to configure Elasticsearch security features on 27-07-2023 08:16:03
#
# --------------------------------------------------------------------------------

# Enable security features
xpack.security.enabled: false

xpack.security.enrollment.enabled: false

# Enable encryption for HTTP API client connections, such as Kibana, Logstash, and Agents
xpack.security.http.ssl:
  enabled: false
  keystore.path: certs/http.p12

# Enable encryption and mutual authentication between cluster nodes
xpack.security.transport.ssl:
  enabled: false
  verification_mode: certificate
  keystore.path: certs/transport.p12
  truststore.path: certs/transport.p12
# Create a new cluster with the current node only
# Additional nodes can still join the cluster later
# cluster.initial_master_nodes: ["es-search-02.europe-west2-b.c.thing-industries-dev-a.internal"]

# Allow HTTP API connections from anywhere
# Connections are encrypted and require user authentication
http.host: 0.0.0.0

# Allow other nodes to join the cluster from anywhere
# Connections are encrypted and mutually authenticated
transport.host: 0.0.0.0

#----------------------- END SECURITY AUTO CONFIGURATION -------------------------
#

# Define the role for this node
node.roles: [ data ]

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


# Enable the service but don't start
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service