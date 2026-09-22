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

# Create a resource group
data "azurerm_resource_group" "rg01" {
  name     = "data-rg"
}

# Create a virtual network within the resource group
data "azurerm_virtual_network" "vnet01" {
  name                = "data-vnet01"
  resource_group_name = data.azurerm_resource_group.rg01. name
}

data "azurerm_subnet" "snet01" {
  name                 = "data-snet"
  resource_group_name  = data.azurerm_resource_group.rg01.name
  virtual_network_name = data.azurerm_virtual_network.vnet01.name

}

resource "azurerm_network_interface" "nic01" {
  name                = "data-nic"
  location            = data.azurerm_resource_group.rg01.location
  resource_group_name = data.azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.snet01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "VM01" {
  name                = "data-vm"
  resource_group_name = data.azurerm_resource_group.rg01.name
  location            = data.azurerm_resource_group.rg01.location
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
}