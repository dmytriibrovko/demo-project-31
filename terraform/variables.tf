variable "project_name" {
  description = "Project name"
}
variable "region" {
  type        = string
  description = "Region name"
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  default = ["10.0.10.0/24", "10.0.20.0/24"]
  type = list
}
variable "availability_zone" {
  description = "Availability zone to create subnet"
  default     = []
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
variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  default     = []
}
variable "user" {
  type        = string
  description = "Username to access the virtual machine"
}
variable "disk_size" {
  type        = number
  description = "Disk Size"
}
variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}
variable "instance_count" {
  description = "Number of Instance"
  default = 2
}