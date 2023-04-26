resource "google_iap_tunnel_instance_iam_binding" "iap_binding" {
  project = var.project_id
  zone = var.zone
  instance = var.instance
  role = var.role
  members = var.members
}