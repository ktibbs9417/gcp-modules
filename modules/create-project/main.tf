locals {
  activate_apis = concat(var.activate_apis, var.activate_additional_apis)
  project_id    = var.project_id == "" ? (var.random_project_id ? random_id.project_id[0].b64_std : var.gcp_project_name) : var.project_id
}

resource "random_id" "project_id" {
  count       = var.random_project_id ? 1 : 0
  byte_length = 2
  prefix      = var.gcp_project_name
}

# Create project
resource "google_project" "project" {
  name                = var.gcp_project_name
  project_id          = local.project_id
  org_id              = var.org_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = var.auto_create_network
  labels = merge(var.labels, {
    project = var.gcp_project_name
  })
}

resource "google_project_service" "api" {
  project                    = google_project.project.number
  for_each                   = toset(var.activate_apis)
  service                    = each.value
  disable_dependent_services = true
  depends_on                 = [google_project.project]
}

resource "google_service_account" "api_service_account" {
  count = var.create_project_srv_accnt ? 1 : 0

  account_id   = "api-service-account"
  display_name = "${var.gcp_project_name} Project Service Account"
  project      = google_project.project.project_id
  depends_on   = [google_project_service.api]
}

/*
  GCE Service Account
*/
resource "google_service_account" "default_service_account" {
  count        = var.create_project_srv_accnt ? 1 : 0
  account_id   = var.gcp_project_name
  display_name = "${var.gcp_project_name} Project Service Account"
  project      = google_project.project.project_id
}

resource "google_project_default_service_accounts" "default_service_accounts" {
  count          = upper(var.default_srv_accnt_action) == "KEEP" ? 0 : 1
  action         = upper(var.default_srv_accnt_action)
  project        = google_project.project.project_id
  restore_policy = "REVERT_AND_IGNORE_FAILURE"
  depends_on     = [google_project.project]
}

module "all_projects_iam_add_member" {
  source     = "../iam-add-member"
  project_id = google_project.project.project_id
  for_each   = var.all_projects_iam_roles
  role       = each.key
  members    = each.value.members
  depends_on = [google_project.project]
}

module "per_project_iam_add_member" {
  source     = "../iam-add-member"
  project_id = google_project.project.project_id
  for_each   = var.per_project_iam_roles
  role       = each.key
  members    = each.value.members
  depends_on = [google_project.project]
}

/*
resource "google_compute_network" "custom_vpc" {
  name                    = var.vpc_name
  project                 = local.project_id
  auto_create_subnetworks = var.auto_create_subnetworks
  depends_on = [google_project.project]
}

resource "google_compute_subnetwork" "custom_vpc_subnets" {
  name          = var.subnet_name
  project       = local.project_id
  ip_cidr_range = var.ip_cidr_range
  region        = var.subnet_region
  network       = google_compute_network.custom_vpc.id
  depends_on = [google_compute_network.custom_vpc]
}
*/
/*
module "per_project_createn_custom_vpc" {
  source = "../new-custom-vpc"
  project_id = google_project.project.project_id
  for_each = var.per_project_custom_vpc
  vpc_name = each.key
  auto_create_subnetworks = each.value.auto_create_subnetworks
  subnet_name = each.value.subnet_name
  ip_cidr_range = each.value.ip_cidr_range
  region = each.value.region

  depends_on = [module.per_project_iam_add_member]
}
*/