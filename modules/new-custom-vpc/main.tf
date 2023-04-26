resource "google_compute_network" "custom_vpc" {
  name                            = var.vpc_name
  project                         = var.project_id
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes_on_create
  auto_create_subnetworks         = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "custom_vpc_subnets" {
  for_each      = var.subnets
  project       = var.project_id
  name          = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.subnet_region
  network       = google_compute_network.custom_vpc.id
  #depends_on = [google_compute_network.custom_vpc]
}