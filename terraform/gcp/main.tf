

variable "project_id"        {}
variable "region_id"            {}
variable "zone_id"            {}
variable "image_occm"        {}
variable "machine_type"          {}
variable "ansible_provision_file" {}
variable "refresh_token"          {}
variable "client_id"              {}
variable "portal_user_name"       {}
variable "auth0_domain"           {}
variable "gcp_json_auth_path"           {}

provider "google" {
  credentials = "${file("${var.gcp_json_auth_path}")}"
  project = "${var.project_id}"  
  region  = "${var.region_id}"
  zone    = "${var.zone_id}"
}

resource "google_compute_instance" "occm-instance" {
  name         = "occm-instance"
  machine_type = "${var.machine_type}"
  tags = ["http-server", "https-server"]
  
  boot_disk {
    initialize_params {
      image = "${var.image_occm}"
    } 
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
        nat_ip = ""
    }
  }
}
resource "null_resource" "ansible-provision" {
  depends_on           = ["google_compute_instance.occm-instance"]

  provisioner "local-exec" {
        command =<<EOF
        ansible-playbook '${var.ansible_provision_file}' --extra-vars 'occm_ip=${google_compute_instance.occm-instance.network_interface.0.access_config.0.nat_ip} \
                                                                        client_id=${var.client_id} \
                                                                        auth0_domain=${var.auth0_domain} \
                                                                        refToken=${var.refresh_token} \
                                                                        portalUserName=${var.portal_user_name}'
        EOF
  }
} 