region      = "eu-north-1"
availability_zone = ["eu-north-1a", "eu-north-1b"]
user = "ubuntu"
public_key_path = "~/.ssh/id_rsa.pub"
worker_instance_type = "t3.micro"
master_instance_type = "t3.small"
worker_disk_size = "20"
master_disk_size = "10"
project_name = "demo-project-31-stage"
public_subnets = ["10.1.10.0/24", "10.1.20.0/24"]
instance_count_worker = 2
instance_count_master = 2