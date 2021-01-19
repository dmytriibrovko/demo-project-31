##------ VPC -------
resource "aws_vpc" "vpc-demo-eks" {
  cidr_block = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -VPC- ${var.common-tags["Project"]}" })
}

##------ Gateway -------
resource "aws_internet_gateway" "igw-demo-eks" {
  vpc_id = aws_vpc.vpc-demo-eks.id
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Gateway- ${var.common-tags["Project"]}" })
}

##------ Subnet public --------
resource "aws_subnet" "subnet_public_eks" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.vpc-demo-eks.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = "true"
  availability_zone_id = data.aws_availability_zones.zones.id
  #availability_zone = element(var.availability_zone, count.index )
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Subnet public first- ${var.common-tags["Project"]}" })
}

##------- Route ----------
resource "aws_route_table" "rtb_public_demo_eks" {
  vpc_id = aws_vpc.vpc-demo-eks.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw-demo-eks.id
  }
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Route- ${var.common-tags["Project"]}" })
}

##----- Route table association ------
resource "aws_route_table_association" "rta_subnet_public-eks" {
  count = length(var.public_subnets)
  subnet_id      = element(aws_subnet.subnet_public_eks.*.id, count.index )
  route_table_id = aws_route_table.rtb_public_demo_eks.id
}
##---- ECS Instance Security group
resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = aws_vpc.vpc-demo-eks.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}