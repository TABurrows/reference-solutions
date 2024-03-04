#!/bin/bash

# Define params
BUCKETS=("project-storage-fn-trigger")

# Notify
echo ""
echo "Read Bucket Contents"
echo "This scripts lists files in the given buckets."

# Query storage
for BUCKET in "${BUCKETS[@]}"	; do

    echo ""
    echo "The bucket $BUCKET contains the following objects:"
    gsutil ls gs://$BUCKET/
    echo "<- end of listing."

done

echo ""
