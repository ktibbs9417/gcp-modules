output "network" {
  value       = google_compute_network.custom_vpc
  description = "The VPC resource being created"
}

output "network_name" {
  value       = google_compute_network.custom_vpc.name
  description = "The name of the VPC being created"
}

output "network_id" {
  value       = google_compute_network.custom_vpc.id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.custom_vpc.self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = var.project_id
  description = "VPC project id"
}
