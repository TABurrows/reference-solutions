#!/bin/bash

# Process:
# 1. Create and configure Base VM
# 2. Create Custom Image from Base VM
# 3. Create Instance Template from Custom Image
# 4. Use Instance Template in Managed Instance Group

# Get the parameters form the .env file
set -a;
source .env;
set +a;

# Create an Instance Template from an existing Instance Template
gcloud beta compute instance-groups managed create $MIG_NAME \
    --zone $ZONE_NAME \
    --template $INST_TPLATE_NAME \
    --base-instance-name $BASE_NAME \
    --size 2 \
    --stateful-disk device-name=persistent-disk-0,auto-delete=on-permanent-instance-deletion \
    --stateful-internal-ip interface-name=nic0,auto-delete=on-permanent-instance-deletion


# # To list managed and unmanaged instance groups
# gcloud compute instance-groups managed list


# # To list managed and unmanaged instance groups
# gcloud compute instance-groups managed delete --zone="..."

