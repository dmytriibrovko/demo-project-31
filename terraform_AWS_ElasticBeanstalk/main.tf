provider "aws" {
  region = var.region
}
##------ VPC -------
resource "aws_vpc" "vpc-demo-ebs3" {
  cidr_block = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -VPC- ${var.common-tags["Project"]}" })
}

##------ Gateway -------
resource "aws_internet_gateway" "igw-demo-ebs3" {
  vpc_id = aws_vpc.vpc-demo-ebs3.id
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Gateway- ${var.common-tags["Project"]}" })
}

##------ Subnet --------
resource "aws_subnet" "subnet_public_ebs3" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.vpc-demo-ebs3.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Subnet public- ${var.common-tags["Project"]}" })
}

##------- Route ----------
resource "aws_route_table" "rtb_public_demo-ebs3" {
  vpc_id = aws_vpc.vpc-demo-ebs3.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw-demo-ebs3.id
  }
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Route- ${var.common-tags["Project"]}" })
}

##----- Route table association ------
resource "aws_route_table_association" "rta_subnet_public-stage" {
  subnet_id      = aws_subnet.subnet_public_ebs3.*.id
  route_table_id = aws_route_table.rtb_public_demo-ebs3.id
}

#--- S3 Bucket ----
resource "aws_s3_bucket" "s3-demo-ebs3" {
  bucket = "s3-${var.project_name}"
  acl    = "private"
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -S3 Bucket- ${var.common-tags["Project"]}" })
}

#--- ElasticBeanstalk ---
resource "aws_elastic_beanstalk_application" "app-demo-ebs3" {
  name        = var.project_name
  description = "${var.common-tags["Environment"]} -elastic_beanstalk- ${var.common-tags["Project"]}"
}
resource "aws_elastic_beanstalk_environment" "env-demo-ebs3" {
  name                = "env-${var.project_name}"
  application         = aws_elastic_beanstalk_application.app-demo-ebs3.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.17 running Python 3.6"

 setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = var.instance_type
  }
}