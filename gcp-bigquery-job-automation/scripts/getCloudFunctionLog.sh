#!/bin/bash

# Define params
REGION_ID="europe-west1"
FUNCTION_NAME="project-fn-load-file"

# Read the function logs
gcloud functions logs read $FUNCTION_NAME --gen2 --region=$REGION_ID