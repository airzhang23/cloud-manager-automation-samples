output "ids" {
  description = "List of IDs of instances"
  value       = "${aws_instance.occm_example.id}"
}

output "ip" {
  description = "List of IPs of instances"
  value       = "${aws_instance.occm_example.public_ip}"
}