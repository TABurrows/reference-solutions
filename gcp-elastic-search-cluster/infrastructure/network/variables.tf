variable "project_id" {
  type = string
}

variable "region_name" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "access_node_tag" {
  type = string
}

variable "allowed_external_ip_addresses" {
  type = list(string)
}

variable "cloud_router_name" {
  type = string
}

variable "cloud_nat_name" {
  type = string
}