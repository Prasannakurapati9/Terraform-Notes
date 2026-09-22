/*terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}*/

module "module-uat" {
  source = "./modules"
  prefixes = "UAT"
  vnet_cidr = "10.40.0.0/24"
  rg_name = "UAT-rg"
  rg_location = "Central India"
  subnet-cidr = "10.40.1.0/25"
}