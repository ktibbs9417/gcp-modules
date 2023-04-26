variable "is_vpc_host_project" {
  type = bool
}

variable "uses_vpc_host_project" {
  type = bool
}

variable "skip_delete" {
  type    = bool
  default = true
}

variable "auto_create_network" {
  type    = bool
  default = false
}

variable "random_project_id" {
  type        = bool
  description = "Whether or not to generate a random suffix at the end of the project_name"
  default     = false
}

variable "host_project_name" {
  type        = string
  description = "The name of the vpc host project"
  default     = ""
}

variable "create_project_srv_accnt" {
  description = "Whether the default service account for the project shall be created"
  type        = bool
  default     = true
}

variable "gcp_project_name" {
  description = "The project name/id for the project"
  type        = string
}

variable "project_id" {
  description = "A user-defined project id for the project"
  type        = string
  default     = "" # If blank, local variable will create a project with random name
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
  default     = "" # Place default value or project wont deploy
}

variable "org_id" {
  description = "The ID of a org to host this project"
  type        = string
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
}

variable "activate_apis" {
  description = "The list of apis to activate within the project"
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

variable "activate_additional_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels needed within project for tracking"
  type        = map(string)
  default     = {}
}

variable "default_srv_accnt_action" {
  description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  default     = "disable"
  type        = string
}

variable "all_projects_iam_roles" {
  type = map(object({
    members = list(string)
  }))
}

variable "per_project_iam_roles" {
  type = map(object({
    members = list(string)
  }))
}

/* 
CREATE CUSTOM NETWORK 
*/
variable "create_custom_vpc" {
  type    = bool
  default = false
}
variable "vpc_name" {
  type    = string
  default = ""
}

variable "auto_create_subnetworks" {
  type    = bool
  default = true
}

variable "subnet_name" {
  type    = string
  default = ""
}
variable "ip_cidr_range" {
  type    = string
  default = ""
}
variable "subnet_region" {
  type    = string
  default = ""
}

/*
variable "per_project_custom_vpc" {
    type = map(object({
    vpc_subnet = list(string)
  }))
}
*/