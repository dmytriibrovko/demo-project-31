output "data_aws_availability_zones" {
  value = data.aws_availability_zones.zones.names
}

output "demo_id" {
  value = aws_instance.demo-project-31.*.id
}

output "demo_public_ip_address" {
  value = aws_eip.demo_static_ip.*.public_ip
}