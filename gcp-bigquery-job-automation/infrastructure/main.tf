# ===========================================================
# Main module
# ===========================================================
provider "google" {
  project = var.project_id
  region  = var.region_id
}



# ===========================================================
# Declare BigQuery
# ===========================================================
module "bigquery" {
  source = "./modules/bigquery"

  bq_dataset_location = var.region_id

  project_labels = var.project_labels

  bq_dataset_id   = var.bq_dataset_id
  bq_dataset_name = var.bq_dataset_name
  bq_dataset_desc = var.bq_dataset_desc
  bq_ds_table_id  = var.bq_ds_table_id

}


# ===========================================================
# Declare Storage
# ===========================================================
module "storage" {
  source = "./modules/storage"

  gcs_bucket_location = var.region_id

  gcs_trigger_bucket_name = var.gcs_trigger_bucket_name

}