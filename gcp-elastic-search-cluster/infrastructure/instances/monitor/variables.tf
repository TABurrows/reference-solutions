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


variable "vm_name" {
  type = string
}

variable "vm_description" {
  type = string
}

variable "vm_type" {
  type = string
}

variable "vm_os" {
  type = string
}


variable "vm_tags" {
  type = list(string)
}

variable "vm_labels" {
  type = object({
    cost_centre = string
  })
}

variable "vm_static_ext_ip_name" {
  type = string
}