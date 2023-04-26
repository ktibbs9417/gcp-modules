variable "project_id" {
    type = string
}

variable "vpc_name" {
  type = string
}

variable "routing_mode" {
  type = string
  default = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}
 variable "delete_default_routes_on_create" {
   type = bool
    description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
   default = false
   
 }
 variable "delete_default_internet_gateway_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  default     = false
}


variable "auto_create_subnetworks" {
    type = bool
      description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
    default = true
}

variable "subnets" {
    type = map(object({
    ip_cidr_range = string
    subnet_region = string
  }))
}




/*
variable "subnet_region" {
  type=string
}

variable "subnet_name" {
  type=string
}

variable "ip_cidr_range" {
  type=string
}
*/