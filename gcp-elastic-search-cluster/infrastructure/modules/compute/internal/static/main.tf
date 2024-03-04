



# =========================================================================
# Define static internal ip
resource "google_compute_address" "internal_static_ip" {
  name = var.vm_static_int_ip_name
  # subnetwork   = google_compute_subnetwork.default.id
  subnetwork   = var.subnet_name
  address_type = "INTERNAL"
  # address      = "10.0.42.42"
  region = var.region_name
}



# =========================================================================
# Define compute instance

resource "google_compute_instance" "main" {
  name           = var.vm_name
  description    = var.vm_description
  machine_type   = var.vm_type
  can_ip_forward = false


  tags = var.vm_tags

  labels = var.vm_labels

  # define the metadata start-up script
  # metadata_startup_script = "sudo apt-get update; sudo apt-get instll -y"

  # metadata = {
  #   serial-port-logging-enable = "FALSE"
  # }

  boot_disk {
    initialize_params {
      image = var.vm_os
    }
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    network_ip = google_compute_address.internal_static_ip.self_link

    # Leave this present for an external ip
    # access_config {
    # Leave this blank for an ephemeral public ip address
    # }

  }

}

