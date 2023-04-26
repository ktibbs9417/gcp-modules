variable "project_id" {}

# role must be either role = "roles/<role>" OR role = "organizations/<role>"
variable "role" {
  type = string

  validation {
    condition     = length(var.role) > 0 ? can(regex("^(roles|organizations)['/']", var.role)) : true
    error_message = "Invalid input, All entries must have 1 of these prefixes: \"roles\", \"organizations\" bad values is ${var.role}."
  }
}

# members must be either: user:{emailid} OR serviceAccount:{emailid} OR group:{emailid} OR domain:{domain}
variable "members" {
  type = list(string)

  validation {
    condition     = length(var.members) > 0 ? alltrue([for o in var.members : can(regex("^(user:|serviceAccount:|group:|domain:)", o))]) : true
    error_message = "Invalid input, member is not in the correct format. All entries must have 1 of these prefixes: user:, serviceAccount:, group: OR domain:."
  }
}

