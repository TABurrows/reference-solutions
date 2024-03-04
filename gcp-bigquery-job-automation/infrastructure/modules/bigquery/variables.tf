# BigQuery module variables

variable "bq_dataset_id" {
  type = string
}

variable "bq_dataset_name" {
  type = string
}

variable "bq_dataset_desc" {
  type = string
}

variable "bq_dataset_location" {
  type = string
}

variable "bq_default_table_expiration" {
  type    = number
  default = 3600000
}

variable "bq_ds_table_id" {
  type = string
}


variable "project_labels" {
  type = object({
    cost_centre = string
  })
}