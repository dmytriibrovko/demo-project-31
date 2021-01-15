variable "region" {
  type        = string
  description = "Region name"
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "Availability zone to create subnet"
}
variable "common-tags" {
  description = "Common Tags to all resources"
  type = map
  default = {
    Owner = "Dmytrii Brovko"
    Project = "demo-project-31"
    Environment = "Stage"
  }
}
variable "instance_type" {
  type        = string
  description = "Type for aws EC2 instance"
}