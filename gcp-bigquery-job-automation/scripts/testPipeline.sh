#!/bin/bash

# Define params
TRIGGER_BUCKET=""project-storage-fn-trigger""
TRIGGER_FILE="$1"


echo "";
if [ -z $1 ]; then
        echo "ERROR: Missing script parameter.";
        echo "eg. ./testPipeline.sh data.json";
        exit 0;
else 

    # Remove old file
    gsutil rm  gs://$TRIGGER_BUCKET/$TRIGGER_FILE

    # Pause
    echo "";
    sleep 5;

    # Copy over trigger data
    echo "";
    gsutil cp $TRIGGER_FILE gs://$TRIGGER_BUCKET/

fi
echo "";
echo "done.";
