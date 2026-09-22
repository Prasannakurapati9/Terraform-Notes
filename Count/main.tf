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
resource "azurerm_resource_group" "rg01" {
  name     = "Count_rg"
  location = "East US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "Vnet01" {
  name                = "Count-vnet"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snet01" {
  count                = 3
  name                 = "Count-snet-${count.index}"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.Vnet01.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
}

resource "azurerm_network_interface" "nic01" {
  count               =3
  name                = "Count-nic-${count.index}"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet01[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "VM" {
  count               = 3
  name                = "Count-VM-${count.index}"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  size                = "Standard_D4_v5"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic01[count.index].id,
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