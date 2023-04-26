/*
output "vpc-host-projects_outputs" {
  value = length(module.vpc-host-projects) > 0 ? module.vpc-host-projects : null
}

output "service-projects_outputs" {
  value = length(module.service-projects) > 0 ? module.service-projects : null
}
*/

output "gcp-projects_outputs" {
  value = length(module.gcp-projects) > 0 ? module.gcp-projects : null
}
