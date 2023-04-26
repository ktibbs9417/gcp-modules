variable "project_id" {
  type        = string
  description = "Project id of the project that holds the network."
}


variable "firewall_rule" {
  description = "map of custom rule definitions (refer to variables file for syntax)."
  type = map(object({
    vpc_name                = string
    description             = string
    direction               = string
    priority                = number
    ranges                  = list(string)
    source_tags             = optional(list(string), [])
    source_service_accounts = optional(list(string), [])
    target_tags             = optional(list(string), [])
    target_service_accounts = optional(list(string), [])
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
    log_config = list(map(string))
  }))
  default = {}
}
