provider "google" {
  # Uncommment and configure the variable below if you're not using GOOGLE_APPLICATION_CREDENTIALS
  # credentials = file(var.gcp_json_key)
  project = var.gcp_project_id
  region  = var.region # Change i
}
####################

# Create project
resource "google_project" "iap-demo-project" {
  name            = var.gcp_project_id
  project_id      = var.gcp_project_id
  #org_id          = var.org_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
}

# Assigns TF Runner to project with Roles
resource "google_project_iam_member" "tf-runner" {
  for_each = toset(var.runner_roles)

  project    = var.gcp_project_id
  role       = each.key
  member     = "serviceAccount:${var.tf_runner}"
  depends_on = [google_project.iap-demo-project]
}

# Create custom svc-account for VMs
resource "google_service_account" "gce-service-account" {
  account_id   = "gce-svc-account"
  display_name = "SVC Account for GCE"
  depends_on = [google_project_iam_member.tf-runner]
}

# Assign users access to custom svc-account
resource "google_service_account_iam_member" "gce-svc-iam" {
  service_account_id = google_service_account.gce-service-account.name
  role               = "roles/iam.serviceAccountUser"

  member  = "user:${var.user_email}"
  depends_on = [google_service_account.gce-service-account]
}

# Enable standard APIs
resource "google_project_service" "apis" {
  project                    = var.gcp_project_id
  for_each                   = toset(var.activate_apis)
  service                    = each.value
  disable_dependent_services = true
  depends_on                 = [google_project_iam_member.tf-runner]
}
####################

# Assign user(s) to have IAP TCP Forwarding access to instances
resource "google_project_iam_member" "iap-member" {
  for_each = toset(var.iap_roles)

  project = var.gcp_project_id
  role    = each.key
  member  = "user:${var.user_email}"
}

resource "google_compute_network" "custom_vpc" {
  name                    = "vpc-network1"
  project                 = var.gcp_project_id
  auto_create_subnetworks = false
  depends_on              = [google_project_service.apis]
}
resource "google_compute_firewall" "allow_iap_ingress" {
  name      = "fw-999-allow-iap-tcp-forwarding"
  network   = google_compute_network.custom_vpc.name
  project   = var.gcp_project_id
  direction = "INGRESS"
  priority  = 999

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_subnetwork" "custom_vpc_subnets" {
  name          = "demo-subnet"
  project       = var.gcp_project_id
  ip_cidr_range = "10.1.0.0/16"
  region        = var.region
  network       = google_compute_network.custom_vpc.id
}

resource "google_compute_instance" "iap-instance" {
  name         = "iap-instance2"
  project      = var.gcp_project_id
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.custom_vpc_subnets.id
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email = google_service_account.gce-service-account.email
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

output "instance_self_link" {
  value = google_compute_instance.iap-instance.self_link
}

