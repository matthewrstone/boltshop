provider "azurerm" { 
    version = "~> 2.17"
    features {}
}

resource "azurerm_windows_virtual_machine" "boltshop" {
  name                = "boltshop-${format("%02d", count.index+1)}"
  count               = var.howmany
  resource_group_name = azurerm_resource_group.boltshop.name
  location            = azurerm_resource_group.boltshop.location
  size                = "Standard_A1_v2"
  admin_username      = "boltadmin"
  admin_password      = "Bolt$hop20"
  custom_data     = base64encode("netsh advfirewall set allprofiles state off")
  // custom_data         = base64encode("${element(data.template_file.init.*.rendered, count.index + 1)}")
  network_interface_ids = ["${element(azurerm_network_interface.boltshop.*.id, count.index + 1)}"]
  os_disk {
      name                 = "boltshop-${format("%02d", count.index+1)}"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
  }
  source_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
  }
  winrm_listener {
    protocol = "Http"
  }
}

resource "azurerm_resource_group" "boltshop" {
  name = "boltshop"
  location = var.location
}

resource "azurerm_subnet" "boltshop" {
  name = "boltshop"
  resource_group_name = azurerm_resource_group.boltshop.name
  virtual_network_name = azurerm_virtual_network.boltshop.name
  address_prefixes = [
      var.cidr
  ]
}

resource "azurerm_virtual_network" "boltshop" {
  name = "boltshop"
  location            = azurerm_resource_group.boltshop.location
  resource_group_name = azurerm_resource_group.boltshop.name
  address_space       = ["${var.cidr}"]
}

resource "azurerm_network_security_group" "boltshop" {
    name = "boltshop"
    location            = azurerm_resource_group.boltshop.location
    resource_group_name = azurerm_resource_group.boltshop.name

    security_rule {
        name      = "winrm"
        priority  = 107
        direction = "Inbound"
        access    = "Allow"
        protocol  = "tcp"
        source_port_range = "*"
        source_address_prefix = "*"
        destination_port_range = "5985"
        destination_address_prefix = "*"
    }
}

resource "azurerm_public_ip" "boltshop" {
  name = "boltshop-${format("%02d", count.index+1)}"
  count                        = var.howmany
  domain_name_label            = "boltshop-${format("%02d", count.index+1)}"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.boltshop.name
  allocation_method            = "Dynamic"
}

resource "azurerm_network_interface" "boltshop" {
    name = "boltshop-${format("%02d", count.index+1)}"
    count                       = var.howmany
    location                    = var.location
    resource_group_name         = azurerm_resource_group.boltshop.name

    ip_configuration {
        name                          = "boltshop-${format("%02d", count.index+1)}"
        subnet_id                     = azurerm_subnet.boltshop.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = element(azurerm_public_ip.boltshop.*.id, count.index+1)
    }
}

resource "azurerm_subnet_network_security_group_association" "boltshop" {
  subnet_id                 = azurerm_subnet.boltshop.id
  network_security_group_id = azurerm_network_security_group.boltshop.id
}
