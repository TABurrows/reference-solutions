#!/bin/bash


# Define params
REGION_ID="europe-west1"
FUNCTION_NAME="project-fn-load-file"

# ------------------------------
# Remove function
# ------------------------------
gcloud functions delete $FUNCTION_NAME --region=$REGION_ID --gen2