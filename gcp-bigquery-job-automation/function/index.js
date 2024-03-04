const functions = require('@google-cloud/functions-framework');
const { BigQuery } = require('@google-cloud/bigquery');
const { Storage } = require('@google-cloud/storage');


// Register a CloudEvent callback with the Functions Framework
functions.cloudEvent('loadFile', async cloudEvent => {


  // const bucketName = 'project-storage-fn-trigger'
  const bucketLocation = 'europe-west1';
  const datasetId = 'my_dataset';
  const tableId = 'my_table';

  // -------------------------------------------------
  // Log info
  // -------------------------------------------------
  // Log cloud event data
  console.log(`Event ID: ${cloudEvent.id}`);
  console.log(`Event Type: ${cloudEvent.type}`);
  // Log file data
  const file = cloudEvent.data;
  console.log(`Bucket: ${file.bucket}`);
  console.log(`File: ${file.name}`);
  console.log(`Metageneration: ${file.metageneration}`);
  console.log(`Created: ${file.timeCreated}`);
  console.log(`Updated: ${file.updated}`);


  // -------------------------------------------------
  // Create BigQuery Load Job with the file name
  // -------------------------------------------------
  console.log("BigQuery Load Job configuration started.")

  // Instantiate clients
  const bigquery = new BigQuery();
  const storage = new Storage();

  // Configure a BigQuery load job.
  const metadata = {
    sourceFormat: 'NEWLINE_DELIMITED_JSON',
    autodetect: true,
    location: bucketLocation,
  };

  // Load data from a Google Cloud Storage file into the table
  const [job] = await bigquery
              .dataset(datasetId)
              .table(tableId)
              .load(storage.bucket(file.bucket).file(file.name), metadata);
              
  // load() waits for the job to finish
  console.log(`BigQuery Load Job ${job.id} completed.`);

  // Check the job's status for errors
  const errors = job.status.errors;
  if (errors && errors.length > 0) {
      throw errors;
  }

});