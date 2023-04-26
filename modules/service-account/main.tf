# Create custom svc-account for VMs
resource "google_service_account" "service_account" {
  for_each = var.service_account
  project = var.project_id
  account_id = each.key
  display_name = each.value.display_name
}

resource "google_service_account_iam_binding" "svc_account_iam" {
  for_each = var.service_account
  service_account_id = "projects/${var.project_id}/serviceAccounts/${each.key}@${var.project_id}.iam.gserviceaccount.com"
  role = each.value.role == "" ? null : each.value.role
  members = each.value.members == "" ? null : each.value.members 
}
