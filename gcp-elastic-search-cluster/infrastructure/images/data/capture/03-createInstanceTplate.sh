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


# # List the existing instance templates:
# gcloud compute instance-templates list
# eg. 'Listed 0 items.'


# # To list all instance template URIs:
# gcloud compute instance-templates list --uri

# # To get the custom image URIs:
# gcloud compute images list --no-standard-images --uri

DEVICE_NAME="persistent-disk-0"

# Create an Instance Template from an existing Image
gcloud compute instance-templates create $INST_TPLATE_NAME \
    --network="$VPC_NAME" \
    --preemptible \
    --provisioning-model=SPOT \
    --instance-termination-action=STOP \
    --region="$REGION_NAME" \
    --subnet="$SUBNET_NAME" \
    --source-instance="$SOURCE_VM_NAME" \
    --source-instance-zone="$ZONE_NAME" \
    --configure-disk=device-name="$DEVICE_NAME",instantiate-from=custom-image,custom-image=projects/$PROJECT_ID/global/images/$IMAGE_NAME,auto-delete=true


# To delete an Instance Template
# gcloud compute instance-templates delete $INST_TPLATE_NAME


