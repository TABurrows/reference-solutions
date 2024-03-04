
# =========================================================================
# Define the provider
provider "google" {
  project = var.project_id
  region  = var.region_name
  zone    = var.zone_name
}

# Define the VPC
module "vpc" {
  source = "../modules/vpc"

  project_id                    = var.project_id
  region_name                   = var.region_name
  vpc_name                      = var.vpc_name
  subnet_name                   = var.subnet_name
  subnet_cidr                   = var.subnet_cidr
  access_node_tag               = var.access_node_tag
  allowed_external_ip_addresses = var.allowed_external_ip_addresses
  cloud_router_name             = var.cloud_router_name
  cloud_nat_name                = var.cloud_nat_name
}