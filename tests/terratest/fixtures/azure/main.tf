terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  is_windows = lower(var.os_type) == "windows"
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "azurerm_network_interface" "test" {
  name                = "image-factory-terratest-nic-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  count                 = local.is_windows ? 0 : 1
  name                  = "image-factory-terratest-linux-${random_string.suffix.result}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.test.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.linux_ssh_public_key
  }

  source_image_id = var.image_id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_windows_virtual_machine" "test" {
  count                 = local.is_windows ? 1 : 0
  name                  = "image-factory-terratest-win-${random_string.suffix.result}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.windows_admin_password
  network_interface_ids = [azurerm_network_interface.test.id]

  source_image_id = var.image_id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

output "vm_id" {
  value = local.is_windows ? azurerm_windows_virtual_machine.test[0].id : azurerm_linux_virtual_machine.test[0].id
}
