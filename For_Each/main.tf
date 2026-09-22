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
resource "azurerm_resource_group" "rg01" {
  for_each   = var.resourcedetails
  name       = each.value.rg_name
  location   = each.value.location
 
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet01" {
  for_each            = var.resourcedetails

  name                = each.value.vnet_name
  resource_group_name = azurerm_resource_group.rg01[each.key].name
  location            = azurerm_resource_group.rg01[each.key].location
  address_space       =["10.0.0.0/16"]
}

resource "azurerm_subnet" "snet01" {
  for_each             = var.resourcedetails

  name                 = each.value.subnet_name
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet01[each.key].name
  resource_group_name  = azurerm_resource_group.rg01[each.key].name
}

resource "azurerm_network_interface" "nic01" {
  for_each             = var.resourcedetails
  name                = "Test-nic"
  location            = azurerm_resource_group.rg01[each.key].location
  resource_group_name = azurerm_resource_group.rg01[each.key].name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.snet01[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "VM01" {
  for_each            = var.resourcedetails

  name                = each.value.computer-name
  resource_group_name = azurerm_resource_group.rg01[each.key].name
  location            = azurerm_resource_group.rg01[each.key].location
  size                = each.value.size
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic01[each.key].id,
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