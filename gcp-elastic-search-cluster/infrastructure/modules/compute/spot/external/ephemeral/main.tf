# =========================================================================
# Define the provider
provider "google" {
  project = var.project_id
  region  = var.region_name
  zone    = var.zone_name
}


# =========================================================================
# External Ephemeral IP

resource "google_compute_instance" "main" {
  name           = var.vm_name
  description    = var.vm_description
  machine_type   = var.vm_type
  # can_ip_forward = false


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

  # Define the network interface parameters
  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name

    # Leave this present for an external ip
    access_config {
      # Leave this blank for an ephemeral public ip address
    }

  }

  # Define the pre-emptible machine scheduling parameters
  scheduling {
    preemptible      = true
    automatic_restart = false
    provisioning_model = "SPOT"
    instance_termination_action = "STOP"
  }

}

