output "public_ip_address" {
  value = "${google_compute_instance.occm-instance.network_interface.0.access_config.0.nat_ip}"
}