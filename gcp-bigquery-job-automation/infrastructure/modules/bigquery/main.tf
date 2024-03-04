# BigQuery Module

# Define the dataset
resource "google_bigquery_dataset" "main" {
  dataset_id                  = var.bq_dataset_id
  friendly_name               = var.bq_dataset_name
  description                 = var.bq_dataset_desc
  location                    = var.bq_dataset_location
  default_table_expiration_ms = var.bq_default_table_expiration

  labels = var.project_labels
}

# Define the table
resource "google_bigquery_table" "main" {

  dataset_id = google_bigquery_dataset.main.dataset_id
  table_id   = var.bq_ds_table_id

  deletion_protection = false

  labels = var.project_labels

  depends_on = [
    google_bigquery_dataset.main
  ]

}