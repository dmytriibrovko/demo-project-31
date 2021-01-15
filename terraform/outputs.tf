output "data_aws_availability_zones" {
  value = data.aws_availability_zones.zones.names
}

output "aws_elastic_beanstalk_solution_stack" {
  value = data.aws_elastic_beanstalk_solution_stack.multi_docker
}