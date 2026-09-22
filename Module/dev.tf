terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}

module "module-dev" {
  source = "./modules"
  rg_location = "Central India"
  prefixes = "dev"
  vnet_cidr = "10.20.0.0/24"
  subnet-cidr = "10.20.1.0/25"
  rg_name = "dev-rg"
}