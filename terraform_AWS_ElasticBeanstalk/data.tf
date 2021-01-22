data "aws_availability_zones" "zones" {}

data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
  most_recent = true
  name_regex = "^64bit Amazon Linux (.*) Python (.*)$"
}

