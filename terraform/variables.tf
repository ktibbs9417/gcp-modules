variable "gcp_project_id" {
  description = "The Google Cloud Platform project ID"
  type        = string
}
variable "region" {
  description = "The Google Cloud Platform Folder ID"
  type        = string
}
variable "zone" {
  description = "The Google Cloud Platform Folder ID"
  type        = string
}
variable "folder_id" {
  description = "The Google Cloud Platform Folder ID"
  type        = string
}
variable "org_id" {
  description = "The Google Cloud Platform Org ID"
  type        = string
}
variable "billing_account" {
  description = "The Billing Account ID used for project"
  type        = string
}

variable "gcp_json_key" {
  description = "The path to the GCP JSON key file"
  type        = string
}

variable "tf_runner" {
  description = "Service Account used to execute TF to GCP"
  type        = string
}

variable "user_email" {
  description = "The user email to grant IAP tunnel access"
  type        = string
}

variable "iap_roles" {
  description = "A list of roles to be assigned to the user"
  type        = list(string)
  default = [
    "roles/iap.tunnelResourceAccessor",
    "roles/compute.instanceAdmin.v1"
  ]
}

variable "runner_roles" {
  description = "A list of roles to be assigned to the user"
  type        = list(string)
  default = [
    "roles/compute.admin",
    "roles/iap.admin"
  ]
}

variable "activate_apis" {
  description = "A list of roles to be assigned to the user"
  type        = list(string)
  default = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "stackdriver.googleapis.com",
    "iap.googleapis.com",
    "cloudbilling.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "bigquery.googleapis.com",
    "recommender.googleapis.com",
    "container.googleapis.com",
    "dataproc.googleapis.com",
    "logging.googleapis.com",
    "billingbudgets.googleapis.com"
  ]
}