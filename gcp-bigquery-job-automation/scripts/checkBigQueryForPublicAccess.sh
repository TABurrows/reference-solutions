#!/bin/bash

# Exit on error
set -e


# Define variables
PROJECT_ID="project-dev-e"
DATASET_NAME="my_dataset"


# Note use
echo ''
echo 'If one or more roles listed below in the ACLs column contain "allUsers" and/or "allAuthenticatedUsers" as members, then the selected Google Cloud BigQuery dataset is publicly accessible.'
echo ''


# Run query
bq show --format=pretty $PROJECT_ID:$DATASET_NAME