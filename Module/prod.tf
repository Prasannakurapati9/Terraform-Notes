/*terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}

*/
module "module-prod" {
  source = "./modules"
  rg_location = "Central India"
  prefixes = "prod"
  vnet_cidr = "10.30.0.0/24"
  rg_name = "prod-rg"
  subnet-cidr = "10.30.1.0/25"
}