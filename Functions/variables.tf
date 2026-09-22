
variable "rg_name" {
    type = string
    description = "this is rg name"
  
}

variable "vnet_name" {
  type = string
  description = "this is vnetname"
}

variable "prefixes" {
  type = string
  description = "this is to add prefix for all resources"
}