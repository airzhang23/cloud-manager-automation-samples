#################
# Provider
#################
provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "/Users/dudub/.aws"
  profile                 = "terraform"  
}

variable "vpc_id"                  {}
variable "security_group_id"       {}
variable "subnet_id"               {}
variable "instance_id"             {}
variable "key_pair"                {}
variable "ansible_provision_file"  {}
variable "refresh_token"           {}
variable "client_id"               {}
variable "portal_user_name"        {}
variable "auth0_domain"            {}


#################
# Data
#################
data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

data "aws_security_group" "selected" {
  id = "${var.security_group_id}"
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_ami" "occm_ami" {
  filter {
    name   = "name"
    values = ["OnCommand_Cloud_Manager_*"]
  }

  most_recent = true
  owners      = ["679593333241"]
}

#################
# Resources
#################

resource "aws_instance" "occm_example" {
  ami                         = "${data.aws_ami.occm_ami.id}"
  instance_type               = "${var.instance_id}"
  key_name                    = "${var.key_pair}"
  vpc_security_group_ids      = ["${data.aws_security_group.selected.id}"]
  subnet_id                   = "${data.aws_subnet.selected.id}"
  associate_public_ip_address = true
  tags {
      Name = "OCCM_example"
  }
  provisioner "local-exec" {
    command =<<EOF
      ansible-playbook '${var.ansible_provision_file}' --extra-vars 'occm_ip=${self.public_ip} \
                                                                    client_id=${var.client_id} \
                                                                    auth0_domain=${var.auth0_domain} \
                                                                    refToken=${var.refresh_token} \
                                                                    portalUserName=${var.portal_user_name}'
    EOF
  }    
}

