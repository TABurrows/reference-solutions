#!/bin/bash

PROJECT_ID="project-dev-e"

SERVICE_ACCOUNT="$(gsutil kms serviceaccount -p $PROJECT_ID)"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:${SERVICE_ACCOUNT}" \
    --role='roles/pubsub.publisher'
