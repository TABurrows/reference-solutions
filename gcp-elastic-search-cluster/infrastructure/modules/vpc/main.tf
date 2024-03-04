# =========================================================================
# VPC Module
# =========================================================================
# Network Resources

# VPC
resource "google_compute_network" "main" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

# Subnet
resource "google_compute_subnetwork" "main" {
  region        = var.region_name
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.main.id
  depends_on = [
    google_compute_network.main
  ]
}

# =========================================================================
# Cloud NAT

# Create Cloud Router for Cloud NAT
resource "google_compute_router" "router" {
  project = var.project_id
  name    = var.cloud_router_name
  network = var.vpc_name
  region  = var.region_name
}

# Create Cloud NAT gateway with Cloud Router
resource "google_compute_router_nat" "nat" {
  name                               = var.cloud_nat_name
  router                             = google_compute_router.router.name
  region                             = var.region_name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


# =========================================================================
# Firewall Rules 

# Allow internal hosts to communicate via ssh
resource "google_compute_firewall" "allow_ssh_es_internal" {
  name    = "allow-ssh-es-internal"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.subnet_cidr]

  destination_ranges = [var.subnet_cidr]

  depends_on = [
    google_compute_subnetwork.main
  ]

}


# Allow external to communicate with tagged hosts via ssh
resource "google_compute_firewall" "allow_ssh_es_external" {
  name    = "allow-ssh-es-external"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.allowed_external_ip_addresses

  target_tags = ["es-access-node", "es-monitor-node"]

  depends_on = [
    google_compute_subnetwork.main
  ]

}

# Allow all external connections via http:80
resource "google_compute_firewall" "allow_http_es_external" {
  name    = "allow-http-es-external"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["es-access-node", "es-monitor-node"]

  depends_on = [
    google_compute_subnetwork.main
  ]

}


# Allow all external connections via https:8443
resource "google_compute_firewall" "allow_https_8443_es_external" {
  name    = "allow-https-8443-es-external"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  source_ranges = var.allowed_external_ip_addresses

  target_tags = ["es-monitor-node"]

  depends_on = [
    google_compute_subnetwork.main
  ]

}


# Allow all external connections via https:443
resource "google_compute_firewall" "allow_https_443_es_external" {
  name    = "allow-https-443-es-external"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = var.allowed_external_ip_addresses

  target_tags = ["es-access-node","es-monitor-node"]

  depends_on = [
    google_compute_subnetwork.main
  ]

}

# Allow internal hosts to communicate over es port 9200-9400 for Elastic Search
resource "google_compute_firewall" "allow_9200-9400_es_internal" {
  name    = "allow-9200-9400-es-internal"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["9200-9400"]
  }

  source_tags = ["es-access-node", "es-monitor-node", "es-search-node"]

  target_tags = ["es-access-node", "es-search-node"]

  depends_on = [
    google_compute_subnetwork.main
  ]

}


# Allow internal hosts to communicate over es port 9100 for Prometheus
resource "google_compute_firewall" "allow_9100_es_internal" {
  name    = "allow-9100-es-internal"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["9100"]
  }

  source_tags = [ "es-monitor-node" ]
  destination_ranges = [ var.subnet_cidr ]

  depends_on = [
    google_compute_subnetwork.main
  ]

}


# Allow internal hosts to communicate over es port 9443 for elasticsearch-head
resource "google_compute_firewall" "allow_9443_es_internal" {
  name    = "allow-9443-es-internal"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["9443"]
  }
  source_ranges = var.allowed_external_ip_addresses

  target_tags = ["es-monitor-node"]


  depends_on = [
    google_compute_subnetwork.main
  ]

}


# =========================================================================
