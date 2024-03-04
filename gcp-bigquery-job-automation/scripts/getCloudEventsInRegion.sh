#!/bin/bash

# Set params
REGION_ID="europe-west1"

# List cloud events in region
gcloud eventarc triggers list --location $REGION_ID