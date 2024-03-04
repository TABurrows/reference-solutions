#!/bin/bash


# Will create an Instance template from the Imager Data Node


# Exit on error
set -e


# Set VM Name definition
SOURCE_VM_NAME=""
SOURCE_ZONE=""


# To extract the ID from the machine:
#  terraform show
# within the root module directory


# To list existing 

# NB if absent then a nearby region is selected
gcloud compute machine-images create es-data-node-base \
    --source-instance=$SOURCE_VM_NAME \
    --source-instance-zone=$SOURCE_ZONE \
    --guest-flush


# Takes a few minutes, when ready the output will be something like:
#
# Created [https://www.googleapis.com/compute/v1/projects/project-12345/global/machineImages/my-machine-image].
# NAME               STATUS
# my-machine-image   READY