# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg01" {
  name     = join("-", ["${var.prefixes}"],["RG01"])
  location = "West Europe"
}

resource "azurerm_storage_account" "stg" {
  name                     = lower(join("", ["${var.prefixes}"], ["stgaccount01"]))
  resource_group_name      = azurerm_resource_group.rg01.name
  location                 = azurerm_resource_group.rg01.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

output "rgname" {
      value = lower(join(",", ["${var.rg_name}, ${var.vnet_name}"]))
}

output "stgname" {
    value = join("", ["${var.prefixes}"],["stgaccount01"])  
}
/*
# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}*/