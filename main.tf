module "gcp-projects" {
  source = "./modules/create-project"

  for_each = var.projects

  gcp_project_name         = each.key
  uses_vpc_host_project    = each.value["uses_vpc_host_project"]
  host_project_name        = (each.value["host_project_name"] != null) ? each.value["host_project_name"] : null
  is_vpc_host_project      = each.value["is_vpc_host_project"]
  billing_account          = (each.value["billing_account"] != "") ? each.value["billing_account"] : null
  org_id                   = (each.value["org_id"] != "") ? each.value["org_id"] : null
  folder_id                = (each.value["folder_id"] != "") ? each.value["folder_id"] : null
  skip_delete              = each.value["skip_delete"]
  auto_create_network      = each.value["auto_create_network"]
  activate_additional_apis = each.value["activate_additional_apis"]
  create_project_srv_accnt = each.value["create_project_srv_accnt"]
  default_srv_accnt_action = each.value["default_srv_accnt_action"]
  labels                   = each.value["labels"]
  all_projects_iam_roles   = var.all_projects_iam_roles
  per_project_iam_roles    = each.value["per_project_iam_roles"]

}

module "service-account" {
  source = "./modules/service-account"

  for_each        = var.service_account
  project_id      = each.value["project_id"]
  service_account = each.value["service_account"]
  depends_on      = [module.gcp-projects]
}

module "custom-vpc" {
  source = "./modules/new-custom-vpc"

  for_each = var.custom_vpc

  project_id                      = each.value["project_id"]
  vpc_name                        = each.key
  routing_mode                    = each.value["routing_mode"]
  delete_default_routes_on_create = each.value["delete_default_routes_on_create"]
  auto_create_subnetworks         = each.value["auto_create_subnetworks"]
  subnets                         = each.value["subnets"]
  depends_on                      = [module.gcp-projects]
}

# Create Firewall Rules to allow SSH for IAP on VPC
module "firewall-rules" {
  source = "./modules/firewall-rules"

  for_each = var.firewall_rules

  project_id    = each.value["project_id"]
  firewall_rule = each.value["firewall_rule"]
  depends_on    = [module.custom-vpc]
}

module "gce-instance" {
  source = "./modules/gce-instance"

  for_each = var.gce_instance

  project_id        = each.value.project_id
  hostname          = each.value.hostname
  machine_type      = each.value.machine_type
  region            = each.value.region
  zone              = each.value.zone
  gce_image         = each.value.gce_image
  tags              = each.value.tags
  labels            = each.value.labels
  network_interface = each.value.network_interface
  #access_config             = (each.value.access_config != "") ? each.value.access_config : null
  gce_service_account_email = (each.value.gce_service_account_email != "") ? each.value.gce_service_account_email : null
  gce_svc_scopes            = (each.value.gce_svc_scopes != "") ? each.value.gce_svc_scopes : null
  metadata                  = (each.value.metadata != "") ? each.value.metadata : null
  metadata_startup_script   = (each.value.metadata_startup_script != "") ? each.value.metadata_startup_script : null

  depends_on = [module.custom-vpc]
}

module "iap-iam" {
  source = "./modules/iap-iam-member"

  for_each = var.iap-iam

  project_id = each.value.project_id
  zone       = each.value.zone
  instance   = each.value.instance
  role       = each.value.role
  members    = each.value.members
  depends_on = [module.gce-instance]
}