# Trigger bucket module


# Create the Trigger bucket
resource "google_storage_bucket" "trigger-bucket" {
  name                        = var.gcs_trigger_bucket_name
  location                    = var.gcs_bucket_location
  uniform_bucket_level_access = true
}