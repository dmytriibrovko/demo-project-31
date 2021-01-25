##------ VPC -------
resource "aws_vpc" "vpc-demo-31-ec2" {
  cidr_block = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -VPC- ${var.common-tags["Project"]}" })
}

##------ Gateway -------
resource "aws_internet_gateway" "igw-demo-31-ec2" {
  vpc_id = aws_vpc.vpc-demo-31-ec2.id
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Gateway- ${var.common-tags["Project"]}" })
}

##------ Subnet public --------
resource "aws_subnet" "subnet_public_demo-31_ec2" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.vpc-demo-31-ec2.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = "true"
  #availability_zone_id = data.aws_availability_zones.zones.id
  availability_zone = element(var.availability_zone, count.index )
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Subnet public first- ${var.common-tags["Project"]}" })
}

##------- Route ----------
resource "aws_route_table" "rtb_public_demo_eks" {
  vpc_id = aws_vpc.vpc-demo-31-ec2.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw-demo-31-ec2.id
  }
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Route- ${var.common-tags["Project"]}" })
}

##----- Route table association ------
resource "aws_route_table_association" "rta_subnet_public-eks" {
  count = length(var.public_subnets)
  subnet_id      = element(aws_subnet.subnet_public_demo-31_ec2.*.id, count.index )
  route_table_id = aws_route_table.rtb_public_demo_eks.id
}
##---- ECS Instance Security group
resource "aws_security_group" "standart" {
  name_prefix = "standart"
  vpc_id      = aws_vpc.vpc-demo-31-ec2.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"

      cidr_blocks = [
        "0.0.0.0/0",
        "10.0.0.0/8",
        "172.16.0.0/12",
        "192.168.0.0/16",
      ]
    }
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}##---- ECS Instance Security group
resource "aws_security_group" "kubernetes_sg" {
  name_prefix = "kubernetes_sg"
  vpc_id      = aws_vpc.vpc-demo-31-ec2.id

  dynamic "ingress" {
    for_each = var.kubernetes_port
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"

      cidr_blocks = [
        "0.0.0.0/0",
        "10.0.0.0/8",
        "172.16.0.0/12",
        "192.168.0.0/16",
      ]
    }
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "node_port_services" {
  cidr_blocks       = var.public_subnets
  description       = "Allows ingress traffic from private subnets to Node Ports"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  security_group_id = aws_security_group.kubernetes_sg.id
  type              = "ingress"
}