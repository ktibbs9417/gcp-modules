variable "projects" {
  type = map(object({
    uses_vpc_host_project    = bool
    host_project_name        = optional(string, "")
    is_vpc_host_project      = bool
    default_srv_accnt_action = string
    create_project_srv_accnt = bool
    #either org_id or folder_id
    org_id                   = string
    folder_id                = optional(string, null)
    billing_account          = optional(string, null)
    skip_delete              = bool
    auto_create_network      = bool
    activate_additional_apis = optional(list(string), [])
    labels                   = map(string)
    per_project_iam_roles = optional(map(object({
      members = list(string)
    })), {})
  }))
  description = "List of project objects."
  default     = {}
}

variable "iap-iam" {
  type = map(object({
    project_id = string
    zone       = string
    instance   = string
    role       = string
    members    = list(string)
  }))
}

variable "service_account" {
  type = map(object({
    project_id = string
    service_account = map(object({
      display_name = string
      role         = optional(string, null)
      members      = optional(list(string), [])
    }))
  }))
  default = {}
}

# vpc_host_projects and service_projects are equal to projects in structure
variable "vpc_host_projects" {
  type        = map(any)
  description = "List of vpc host project objects. these must be created first"
  default     = {}
}

variable "service_projects" {
  type        = map(any)
  description = "List of service project objects. these must be created after vpc host projects"
  default     = {}
}

variable "all_projects_iam_roles" {
  type = map(object({
    members = list(string)
  }))
  default = {}
}

variable "custom_vpc" {
  type = map(object({
    project_id                      = optional(string, null)
    vpc_name                        = optional(string, null)
    auto_create_subnetworks         = optional(bool)
    routing_mode                    = optional(string, null)
    delete_default_routes_on_create = optional(bool)
    subnets = optional(map(object({
      ip_cidr_range = string
      subnet_region = string
    })), {})
  }))
}

variable "firewall_rules" {
  type = map(object({
    project_id = string
    firewall_rule = optional(map(object({
      vpc_name                = string
      description             = string
      direction               = string
      priority                = number
      ranges                  = optional(list(string), [])
      source_tags             = optional(list(string), [])
      source_service_accounts = optional(list(string), [])
      target_tags             = optional(list(string), [])
      target_service_accounts = optional(list(string), [])
      allow = optional(list(object({
        protocol = string
        ports    = list(string)
      })), [])
      deny = optional(list(object({
        protocol = string
        ports    = list(string)
      })), [])
      log_config = optional(list(map(string)), [])
    })), {})
  }))
}

variable "gce_instance" {
  type = map(object({
    project_id   = string
    hostname     = string
    machine_type = string
    region       = string
    zone         = string
    gce_image    = string
    tags         = optional(list(string), [])
    labels       = map(string)
    network_interface = map(object({
      subnet_name = string
    }))
    /*
    access_config = optional(map(object({
      nat_ip       = string
      network_tier = string
    })), {})
    */
    gce_service_account_email = optional(string)
    gce_svc_scopes            = optional(list(string), [])
    metadata                  = optional(map(string), {})
    metadata_startup_script   = optional(string)
  }))
}