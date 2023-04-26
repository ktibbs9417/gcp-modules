variable "project_id" {
  type = string
}


variable "service_account" {
  type = map(object({
    display_name = string
    role         = optional(string, "")
    members      = optional(list(string), [])
  }))
  default = {}
}