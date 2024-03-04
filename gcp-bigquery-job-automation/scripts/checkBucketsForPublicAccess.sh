#!/bin/bash

# Exit on error
set -e


# Define variables
BUCKETS=("project-storage-fn-trigger")

# Note use
echo ""
echo "Check Buckets for Public Access"
echo 'If the list of IAM member names returned by this script contains "allUsers" and/or "allAuthenticatedUsers", the selected Google Cloud Storage bucket is publicly accessible. '
echo ""

# Query storage
for BUCKET in "${BUCKETS[@]}"	; do

	echo "Querying Bucket $BUCKET ..."
	gsutil iam get gs://$BUCKET/ \
		--format=json | jq '.bindings[].members[]'
	echo ""

done
