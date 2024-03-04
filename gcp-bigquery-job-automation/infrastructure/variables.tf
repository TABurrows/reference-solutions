
# ===========================================================
# Globals
# ===========================================================

variable "project_id" {
  type = string
}

variable "region_id" {
  type = string
}



# ===========================================================
# BigQuery
# ===========================================================

variable "bq_dataset_id" {
  type = string
}

variable "bq_dataset_name" {
  type = string
}

variable "bq_dataset_desc" {
  type = string
}

variable "bq_ds_table_id" {
  type = string
}

variable "project_labels" {
  type = object({
    cost_centre = string
  })
}



# ===========================================================
# Storage
# ===========================================================

variable "gcs_trigger_bucket_name" {
  type = string
}
