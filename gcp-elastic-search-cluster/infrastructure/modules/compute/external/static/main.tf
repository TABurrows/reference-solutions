# =========================================================================
# Define the provider
provider "google" {
  project = var.project_id
  region  = var.region_name
  zone    = var.zone_name
}


# =========================================================================
# Static External IP

resource "google_compute_address" "static" {
  name   = var.vm_static_ext_ip_name
  region = var.region_name
}


# =========================================================================
# Compute instance
resource "google_compute_instance" "main" {
  name           = var.vm_name
  description    = var.vm_description
  machine_type   = var.vm_type
  can_ip_forward = false

  # define the metadata start-up script
  # metadata_startup_script = "sudo apt-get update; sudo apt-get instll -y"

  # metadata = {
  #   serial-port-logging-enable = "FALSE"
  # }

  tags = var.vm_tags

  labels = var.vm_labels

  boot_disk {
    initialize_params {
      image = var.vm_os
    }
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name

    access_config {
      # Leave this blank for an ephemeral public ip address
      # or assign a static ip with
      nat_ip = google_compute_address.static.address
    }

  }

}
