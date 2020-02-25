variable "subscription_id"        {}
variable "resource_group"         {}
variable "location_id"            {}
variable "virtual_network"        {}
variable "subnet_id"              {}
variable "image_publisher"        {}
variable "image_offer"            {}
variable "image_sku"              {}
variable "image_version"          {}
variable "managed_disk_type"      {}
variable "vm_admin_user"          {}
variable "vm_admin_password"      {}
variable "instance_type"          {}
variable "ansible_provision_file" {}
variable "ansible_prerequisites"  {}
variable "refresh_token"          {}
variable "client_id"              {}
variable "portal_user_name"       {}
variable "auth0_domain"           {}
variable "use_existing_resources" {}     

resource "null_resource" "ansible-prerequisites" {

  provisioner "local-exec" {
        command =<<EOF
        ansible-playbook '${var.ansible_prerequisites}' --extra-vars 'az_rg=${var.resource_group} \
                                                                      az_vn=${var.virtual_network} \
                                                                      az_sn=${var.subnet_id} \  
                                                                      use_existing_resources=${var.use_existing_resources}'
        EOF
  }
}  


# Configure the Microsoft Azure Provider
provider "azurerm" {
    subscription_id  = "${var.subscription_id}"
    version = "=2.0.0"
    features {}
    #version = "=2.0.0"
#    client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#    client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#    tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# Create a resource group
resource "azurerm_resource_group" "occmgroup" {
  count      = "${var.use_existing_resources ? 0 : 1}"  
  name       = "${var.resource_group}"
  location   = "${var.location_id}"
  depends_on = ["null_resource.ansible-prerequisites"]
}

# Create a resource group
data "azurerm_resource_group" "occmgroup" {
  name     = "${var.use_existing_resources ? var.resource_group : join("", azurerm_resource_group.occmgroup.*.name)}"
  depends_on = ["null_resource.ansible-prerequisites"]
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "occmvnet" {
  count               = "${var.use_existing_resources ? 0 : 1}"      
  name                = "${var.virtual_network}"
  resource_group_name = "${azurerm_resource_group.occmgroup[0].name}"
  location            = "${azurerm_resource_group.occmgroup[0].location}"
  address_space       = ["10.0.0.0/16"]
}

# Create a virtual network within the resource group
data "azurerm_virtual_network" "occmvnet" {
  name                = "${var.use_existing_resources ? var.virtual_network : join("", azurerm_virtual_network.occmvnet.*.name)}"
  resource_group_name = "${data.azurerm_resource_group.occmgroup.name}"
}

resource "azurerm_subnet" "occmsubnet" {
  count                = "${var.use_existing_resources ? 0 : 1}"      
  name                 = "${var.subnet_id}"
  resource_group_name  = "${azurerm_resource_group.occmgroup[0].name}"
  virtual_network_name = "${azurerm_virtual_network.occmvnet[0].name}"
  address_prefix       = "10.0.1.0/24"
}

data "azurerm_subnet" "occmsubnet" {
  name                 = "${var.use_existing_resources ? var.subnet_id : join("", azurerm_subnet.occmsubnet.*.name)}"
  resource_group_name  = "${data.azurerm_resource_group.occmgroup.name}"
  virtual_network_name = "${data.azurerm_virtual_network.occmvnet.name}"
}

# Create public IPs
resource "azurerm_public_ip" "occmpublicip" {
    name                         = "OccmPublicIPDEMO111110"
    location                     = "${data.azurerm_resource_group.occmgroup.location}"
    resource_group_name          = "${data.azurerm_resource_group.occmgroup.name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "OCCM Demo"
    }
}

data "azurerm_public_ip" "occmip" {
    name                = "${azurerm_public_ip.occmpublicip.name}"
    resource_group_name = "${data.azurerm_resource_group.occmgroup.name}"
    depends_on           = ["azurerm_virtual_machine.occmvm"]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "occmnsg" {
    name                = "OccmNetworkSecurityGroupDEMO111110"
    location            = "${data.azurerm_resource_group.occmgroup.location}"
    resource_group_name = "${data.azurerm_resource_group.occmgroup.name}"

    security_rule {
        name                       = "HTTP"
        priority                   = 1010
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTPS"
        priority                   = 1020
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    
    security_rule {
        name                       = "SSH"
        priority                   = 1030
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }    

    tags = {
        environment = "OCCM Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "occmnic" {
    name                      = "OccmNICDEMO111110"
    location                  = "${var.location_id}"
    resource_group_name       = "${data.azurerm_resource_group.occmgroup.name}"
    #network_security_group_id = "${azurerm_network_security_group.occmnsg.id}"

    ip_configuration {
        name                          = "myNicConfigurationDEMO111110"
        subnet_id                     = "${data.azurerm_subnet.occmsubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.occmpublicip.id}"
    }

    tags = {
        environment = "OCCM Demo"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "occmvm" {
    name                          = "OccmVmDEMO111110"
    location                      = "${var.location_id}"
    resource_group_name           = "${data.azurerm_resource_group.occmgroup.name}"
    network_interface_ids         = ["${azurerm_network_interface.occmnic.id}"]
    vm_size                       = "${var.instance_type}"
    delete_os_disk_on_termination = "true"

    storage_os_disk {
        name              = "OccmOsDiskDEMO111110"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "${var.managed_disk_type}"
    }

    storage_image_reference {
        publisher = "${var.image_publisher}"
        offer     = "${var.image_offer}"
        sku       = "${var.image_sku}"
        version   = "${var.image_version}"
    }

    plan {
        name = "${var.image_sku}"
        product = "${var.image_offer}"
        publisher = "${var.image_publisher}"
    }    

    # User/Passowrd Authentication
    os_profile {
        computer_name  = "occmvm"
        admin_username = "${var.vm_admin_user}"
        admin_password = "${var.vm_admin_password}"
    }
    
    os_profile_linux_config {
        disable_password_authentication = false
    }    

    tags = {
        environment = "OCCM Demo"
    }

}

resource "null_resource" "ansible-provision" {

  provisioner "local-exec" {
        command =<<EOF
        ansible-playbook '${var.ansible_provision_file}' --extra-vars 'occm_ip=${data.azurerm_public_ip.occmip.ip_address} \
                                                                        client_id=${var.client_id} \
                                                                        auth0_domain=${var.auth0_domain} \
                                                                        refToken=${var.refresh_token} \
                                                                        portalUserName=${var.portal_user_name}'
        EOF
  }
}  

