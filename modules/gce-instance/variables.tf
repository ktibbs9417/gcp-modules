variable "project_id" {
  type = string
}

variable "hostname" {
  type = string
}

variable "machine_type" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "zone" {
  type    = string
  default = ""
}

variable "gce_image" {
  type    = string
  default = ""
}

variable "labels" {
  type    = map(string)
  default = {}
}


variable "tags" {
  type = list(string)
}

variable "network_interface" {
  type = map(object({
    subnet_name = string
  }))
}

/*
variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    nat_ip       = optional(string)
    network_tier = optional(string)
}))
}
*/
variable "gce_service_account_email" {
  type    = string
  default = ""
}

variable "gce_svc_scopes" {
  type = list(string)
  default = ["https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/pubsub",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
  "https://www.googleapis.com/auth/trace.append"]
}


variable "metadata" {
  type    = map(string)
  default = {}
}

variable "metadata_startup_script" {
  type    = string
  default = ""
}

