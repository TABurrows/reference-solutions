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


# To get a list of custom images (ie. non-standard images)
# gcloud compute images list --no-standard-images

# To get a list of custom images with their uris
# gcloud compute images list --no-standard-images --uri


# 2. Create Custom Image from shutdown Base VM
# (can take a few minutes)
gcloud compute images create $IMAGE_NAME \
    --source-disk="$SOURCE_DISK" \
    --source-disk-zone="$SOURCE_DISK_ZONE" \
    --storage-location="$STORAGE_LOCATION"


# Sample output:
# Created [https://www.googleapis.com/compute/v1/projects/project-c/global/images/custom-image-name].
# NAME                    PROJECT                 FAMILY  DEPRECATED  STATUS
# custom-image-name       project-c                                   READY
#
# Confirm Custom Image creation:
# gcloud compute images list --no-standard-images
#  and
# gcloud compute images list --no-standard-images --uri
