
# =========================================================================
# Define the provider
provider "google" {
  project = var.project_id
  region  = var.region_name
  zone    = var.zone_name
}

# # =========================================================================
# # Define static internal ip
# resource "google_compute_address" "internal_with_subnet_and_address" {
#   name         = "my-internal-address"
#   subnetwork   = google_compute_subnetwork.default.id
#   address_type = "INTERNAL"
#   address      = "10.0.42.42"
#   region       = "us-central1"
# }



# =========================================================================
# Define the instance
module "instance" {
  source = "../../modules/compute/internal/static"

  project_id  = var.project_id
  region_name = var.region_name
  zone_name   = var.zone_name

  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name

  vm_name        = var.vm_name
  vm_description = var.vm_description
  vm_type        = var.vm_type
  vm_os          = var.vm_os

  vm_tags   = var.vm_tags
  vm_labels = var.vm_labels

  vm_static_int_ip_name = var.vm_static_int_ip_name
}