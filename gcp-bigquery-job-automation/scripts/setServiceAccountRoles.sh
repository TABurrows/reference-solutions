#!/bin/bash


# Define params
PROJECT_ID="project-dev-e"


# Service Account details
SVC_ACC_NAME="svc-acc-data-ingress"



# Define the required roles for the service account
ROLES=( "roles/cloudbuild.builds.editor" \
        "roles/run.admin" \
        "roles/eventarc.admin" \
        "roles/logging.viewAccessor" \
        "roles/resourcemanager.projectIamAdmin" \
        "roles/iam.serviceAccountAdmin" \
        "roles/iam.serviceAccountUser" \
        "roles/serviceusage.serviceUsageAdmin" \
        "roles/bigquery.jobUser" \
        "roles/storage.admin" )

# Add the roles to the service account
for ROLE in "${ROLES[@]}"; do
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SVC_ACC_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
        --role="${ROLE}"
done


