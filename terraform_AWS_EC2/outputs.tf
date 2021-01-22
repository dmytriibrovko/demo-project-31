output "data_aws_availability_zones" {
  value = data.aws_availability_zones.zones.names
}

output "worker_public_ip_address" {
  value = aws_eip.worker_static_ip.*.public_ip
}

output "master_public_ip_address" {
  value = aws_eip.master_static_ip.*.public_ip
}