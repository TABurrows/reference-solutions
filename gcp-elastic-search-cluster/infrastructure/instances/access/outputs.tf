
# Output the public ip assigned to the instance
output "public_ip" {
  description = "Public IP Address"
  value       = module.instance.public_ip
}