provider "aws" {
  region = var.region
}

data "aws_availability_zones" "zones" {}

data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
  most_recent = true
  name_regex = "^64bit Amazon Linux (.*) Python (.*)$"
}

##------ VPC -------
resource "aws_vpc" "vpc-demo-31" {
  cidr_block = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -VPC- ${var.common-tags["Project"]}" })
}

##------ Gateway -------
resource "aws_internet_gateway" "igw-demo-31" {
  vpc_id = aws_vpc.vpc-demo-31.id
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Gateway- ${var.common-tags["Project"]}" })
}

##------ Subnet --------
resource "aws_subnet" "subnet_public_demo_31" {
  vpc_id = aws_vpc.vpc-demo-31.id
  cidr_block = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Subnet public- ${var.common-tags["Project"]}" })
}

##------- Route ----------
resource "aws_route_table" "rtb_public_demo_31" {
  vpc_id = aws_vpc.vpc-demo-31.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw-demo-31.id
  }
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Route- ${var.common-tags["Project"]}" })
}

##----- Route table association ------
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public_demo_31.id
  route_table_id = aws_route_table.rtb_public_demo_31.id
}

#--- S3 Bucket ----
resource "aws_s3_bucket" "s3-demo-31" {
  bucket = "s3-demo-31"
  acl    = "private"
  tags = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -S3 Bucket- ${var.common-tags["Project"]}" })
}

#--- ElasticBeanstalk ---
resource "aws_elastic_beanstalk_application" "app-demo-31" {
  name        = "demo-31"
  description = "${var.common-tags["Environment"]} -elastic_beanstalk- ${var.common-tags["Project"]}"
}
resource "aws_elastic_beanstalk_environment" "env-demo-31" {
  name                = "env-demo-31"
  application         = aws_elastic_beanstalk_application.app-demo-31.name
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

#--- EKC ---