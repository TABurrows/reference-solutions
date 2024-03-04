#!/bin/bash


# Define params
PROJECT_ID="project-dev-e"


# Service Account details
SVC_ACC_NAME="svc-acc-data-ingress"
SVC_ACC_DESC="The Service Account to be used by a Cloud Function to drive data into BigQuery."
SVC_ACC_DISP_NAME=$SVC_ACC_NAME



# Create a service account
gcloud iam service-accounts create $SVC_ACC_NAME \
    --description="$SVC_ACC_DESC" \
    --display-name="$SVC_ACC_DISP_NAME"
