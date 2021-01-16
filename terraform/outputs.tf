output "data_aws_availability_zones" {
  value = data.aws_availability_zones.zones.names
}
output "aws_elastic_beanstalk_solution_stack" {
  value = data.aws_elastic_beanstalk_solution_stack.multi_docker
}
output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}
output "cluster_sg" {
  value = module.cluster.cluster_security_group_id
}
output "kubectl_config" {
  value = module.cluster.kubeconfig
}
output "config_map_aws_auth" {
  value = module.cluster.config_map_aws_auth
}