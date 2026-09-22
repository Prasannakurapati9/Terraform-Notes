
variable "resourcedetails" {
    type = map(object({
     computer-name  = string
      location      = string 
      size          = string
      rg_name       = string
      vnet_name     = string
      subnet_name   = string
    
    }))
  default = {
    "Central India" = {
       computer-name = "India-VM"
        location    = "Central India"
        size        = "Standard_B2s"
        rg_name     = "Each-rg"
        vnet_name   = "India_vnet"
        subnet_name = "India_snet"
    }
    "East US" = {
        computer-name = "EastUS-VM"
        location    = "EastUS"
        size        = "Standard_B1s"
        rg_name     = "EastUS_rg"
        vnet_name   = "EastUS_vnet"
        subnet_name = "EastUS_snet"
  }
}
}
