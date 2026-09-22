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

terraform {
  backend "azurerm" {
    access_key           = "5IpAr9OamOcAV+0+ygUy7l731qr5oCr0bH8WkOSHYDjNVlX4Xg17m4FMsyzDnpG66lzUhfYT2Tv6+AStdE9E2A=="  # Can also be set via `ARM_ACCESS_KEY` environment variable.
    storage_account_name = "backendstg01"                                 # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "backend-container"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"                   # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

resource "azurerm_resource_group" "rg01" {
  name     = "${var.prefixes}-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet01" {
  name                = "${var.prefixes}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
}

resource "azurerm_subnet" "snet01" {
  name                 = "${var.prefixes}-snet"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic01" {
  name                = "${var.prefixes}-nic"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "myVMPIP01" {
  name                = "${var.prefixes}-ip"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "VM" {
  name                = "${var.prefixes}-VM"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  size                = "Standard_D4_v5"
  admin_username      = "adminuser"
  admin_password      = "Nationindia@91"
  network_interface_ids = [
    azurerm_network_interface.nic01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts"
    version   = "latest"
  }


}