resource "google_compute_instance" "gce-instance" {
  #for_each = var.vm_instance

  name         = var.hostname
  project      = var.project_id
  machine_type = var.machine_type
  zone         = var.zone
  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.gce_image
      labels = var.labels  == "" ? null : var.labels
    }
  }
  
  dynamic "network_interface"{
    for_each = var.network_interface

    content {
          subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${network_interface.value.subnet_name}" == "" ? null : "projects/${var.project_id}/regions/${var.region}/subnetworks/${network_interface.value.subnet_name}"
    }
  }

 # metadata = var.metadata  == "" ? null : var.metadata
  metadata_startup_script = var.metadata_startup_script == "" ? null : var.metadata_startup_script
  
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email = (var.gce_service_account_email != "") ? var.gce_service_account_email : null
    scopes = var.gce_svc_scopes
  }
}