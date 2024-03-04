
# Output the public ip assigned to the instance
output "public_ip" {
  description = "Public IP Address"
  value       = google_compute_instance.main.network_interface.0.access_config.0.nat_ip
}
