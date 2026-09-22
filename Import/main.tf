
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

#create a local to store bigger variables in this file

# Create a resource group
resource  "azurerm_resource_group" "rg01" {
  name    = "Import-rg"
  location = "East US "
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet01" {
  name                = "Import-Vnet"
  resource_group_name = "azurerm_resource_group.rg01.name"
  location            = "azurerm_resource_group.rg01.location"
  address_space      =  ["10.0.0.0/16"] 
}

resource "azurerm_subnet" "snet01" {
  name                 = "Subnet1"
  resource_group_name  = "azurerm_resource_group.rg01.name"
  virtual_network_name = "azurerm_virtual_network.vnet01.name"
  address_prefixes     = ["10.0.0.0/24"]

}
/*
resource "azurerm_network_interface" "nic01" {
  name                = "data-nic"
  location            = local.location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.snet01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "VM01" {
  name                = "data-vm"
  resource_group_name = local.rg_name
  location            = local.location
  size                = "Standard_D4_v5"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}*/