provider "aws" {
  region = var.region
}
data "aws_availability_zones" "zones" {}

##------SSH key----------
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = file(var.public_key_path)
}
resource "aws_eip" "master_static_ip" {
  count = var.instance_count_master
  instance = element(aws_instance.demo-project-31-master.*.id,count.index)

  depends_on = [aws_instance.demo-project-31-master]
}
resource "aws_eip" "worker_static_ip" {
    count = var.instance_count_worker
    instance = element(aws_instance.demo-project-31-worker.*.id,count.index)

  depends_on = [aws_instance.demo-project-31-worker]
}

##------Instance---------
data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_instance" "demo-project-31-master" {
  count = var.instance_count_master
  ami =  data.aws_ami.latest_ubuntu.id
  instance_type = var.master_instance_type
  vpc_security_group_ids = [aws_security_group.standart.id, aws_security_group.kubernetes_sg.id]
  subnet_id = aws_subnet.subnet_public_demo-31_ec2[count.index].id
  key_name = aws_key_pair.ec2key.key_name

  depends_on = [aws_subnet.subnet_public_demo-31_ec2]

  #user_data = templatefile("var.user:file("./")")

  root_block_device {
    volume_size = var.master_disk_size
  }
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} Master ${var.common-tags["Project"]}", Status = "master" })
}
resource "aws_instance" "demo-project-31-worker" {
  count = var.instance_count_worker
  ami =  data.aws_ami.latest_ubuntu.id
  instance_type = var.worker_instance_type
  vpc_security_group_ids = [aws_security_group.standart.id, aws_security_group.kubernetes_sg.id]
  subnet_id = aws_subnet.subnet_public_demo-31_ec2[count.index].id
  key_name = aws_key_pair.ec2key.key_name

  depends_on = [aws_subnet.subnet_public_demo-31_ec2]

  #user_data = templatefile("var.user:file("./")")

  root_block_device {
    volume_size = var.worker_disk_size
  }
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} Worker ${var.common-tags["Project"]}", Status = "master" })
}

resource "local_file" "hosts_cfg" {
  content = templatefile("templates/inventory.tpl",
  {
    user = var.user
    master = aws_eip.master_static_ip.*.public_ip
    worker = aws_eip.worker_static_ip.*.public_ip
  }
  )
  filename = "../ansible/inventory/hosts.cfg"
}
