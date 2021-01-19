##------SSH key----------
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = file(var.public_key_path)
}

resource "aws_eip" "demo_static_ip" {
    count = var.instance_count
    instance = aws_eip.demo_static_ip.*.id

  depends_on = [aws_instance.demo-project-31]
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
resource "aws_instance" "demo-project-31" {
  count = var.instance_count
  ami =  data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type
  vpc_security_group_ids = aws_security_group.all_worker_mgmt.id
  subnet_id = aws_subnet.subnet_public_eks.*.id
  key_name = aws_key_pair.ec2key.key_name

  #user_data = templatefile("var.user:file("./")")

  root_block_device {
    volume_size = var.disk_size
  }
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} ${var.common-tags["Project"]}" })
}