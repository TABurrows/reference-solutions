#!/bin/bash

# Define logstash version
# Needs to match search
ES_VERSION="8.8.2"

# Download a specific version of Logstash
cd /tmp
wget https://artifacts.elastic.co/downloads/logstash/logstash-$ES_VERSION-amd64.deb


# Install the deb
sudo dpkg -i /tmp/logstash-$ES_VERSION-amd64.deb
# nb. installer from DEB adds /etc/logstash and /usr/share/logstash
#       and binary located at /usr/share/logstash/bin/logstash


# Create/edit a logstash.yml from logstash-sample.conf
#  eg. cp /etc/logstash/logstash-sample.conf /etc/logstash/logstash.yml


# If you get the startup error, 
#   set   /usr/share/logstash/data   writable
sudo chmod -R a+rw /usr/share/logstash/data



# Reload, enable and start the logstash service
sudo systemctl daemon-reload
sudo systemctl enable logstash
sudo systemctl start logstash



# Inline Testing:
# Stop the service
# Run the cli from the prompt with a test conf / pipeline
# from [ https://www.elastic.co/blog/a-practical-introduction-to-logstash ]
# /usr/share/logstash/bin/logstash -r -f "/home/admin_thing_industries/logTest1.conf"
