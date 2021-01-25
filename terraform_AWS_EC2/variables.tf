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
  default = ["10.1.10.0/24", "10.1.20.0/24"]
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
variable "worker_instance_type" {
  type        = string
  description = "Type for aws EC2 instance for Worker node"
}
variable "master_instance_type" {
  type        = string
  description = "Type for aws EC2 instance for Master node"
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  default     = []
}
variable "user" {
  type        = string
  description = "Username to access the virtual machine"
}
variable "worker_disk_size" {
  type        = number
  description = "Disk Size"
}
variable "master_disk_size" {
  type        = number
  description = "Disk Size"
}
variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}
variable "instance_count_worker" {
  description = "Number of Instance"
  default = 2
}
variable "instance_count_master" {
  description = "Number of Instance"
  default = 2
}
variable "allow_ports" {
  description = "List of ports to open for server"
  type = list
  default = ["80","443","22","8080"]
}
variable "kubernetes_port" {
  description = "List of ports to open for Kubernetes"
  type = list
}