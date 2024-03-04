#!/bin/bash

# https://www.elastic.co/guide/en/logstash/current/plugins-inputs-google_pubsub.html



# Prep:
#  Ensure the Pub/Sub API is enabled



# # List current plugins and check not installed
# /usr/share/logstash/bin/logstash-plugin list
# /usr/share/logstash/bin/logstash-plugin list | grep pubsub



# Install the plugin by running
/usr/share/logstash/bin/logstash-plugin install logstash-input-google_pubsub



# Create a service account that can read from a pubsub subcritpion
#  (also looks like create subscription permission is required)



# Configure application default credentials



# or, create a service account 



# For Pub/Sub Testing
# ---------------------------------
# Create the plugin conf file:
#   /etc/logstash/conf.d/pubsub.conf
# containing the example:
#
#
# input {
#     google_pubsub {
#         # Your GCP project id (name)
#         project_id => "my-project-1234"

#         # The topic name below is currently hard-coded in the plugin. You
#         # must first create this topic by hand and ensure you are exporting
#         # logging to this pubsub topic.
#         topic => "logstash-input-dev"

#         # The subscription name is customizeable. The plugin will attempt to
#         # create the subscription (but use the hard-coded topic name above).
#         subscription => "logstash-sub"

#         # If you are running logstash within GCE, it will use
#         # Application Default Credentials and use GCE's metadata
#         # service to fetch tokens.  However, if you are running logstash
#         # outside of GCE, you will need to specify the service account's
#         # JSON key file below.
#         #json_key_file => "/home/erjohnso/pkey.json"

#         # Should the plugin attempt to create the subscription on startup?
#         # This is not recommended for security reasons but may be useful in
#         # some cases.
#         #create_subscription => false
#     }
# }
# output { stdout { codec => rubydebug } }
#