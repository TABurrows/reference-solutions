#!/bin/bash



# Define Params
PROJECT_ID="project-dev-e"
FUNCTION_NAME="project-fn-load-file"
TRIGGER_BUCKET="project-storage-fn-trigger"

REGION_ID="europe-west1"
SOURCE_LOCATION="."
RUNTIME="nodejs18"
CODE_ENTRYPOINT="loadFile"
EVENT_TYPE="type=google.cloud.storage.object.v1.finalized"
EVENT_BUCKET="bucket=$TRIGGER_BUCKET"
SERVICE_ACCOUNT="svc-acc-data-ingress@$PROJECT_ID.iam.gserviceaccount.com"



# ------------------------------
# Enable Required APIs:
# ------------------------------
gcloud services enable \
            cloudbuild.googleapis.com \
            eventarc.googleapis.com \
            pubsub.googleapis.com \
            run.googleapis.com \
            storage.googleapis.com


# ------------------------------
# Deploy function
# ------------------------------
gcloud functions deploy $FUNCTION_NAME \
            --gen2 \
            --region=$REGION_ID \
            --runtime=$RUNTIME \
            --source=$SOURCE_LOCATION \
            --entry-point=$CODE_ENTRYPOINT \
            --service-account=$SERVICE_ACCOUNT \
            --trigger-event-filters=$EVENT_TYPE \
            --trigger-event-filters=$EVENT_BUCKET 

