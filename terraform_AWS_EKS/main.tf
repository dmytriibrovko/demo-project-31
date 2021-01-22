provider "aws" {
  region = var.region
}
#----- k8s cluster -------
data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

module "cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.project_name
  cluster_version = "1.17"
  subnets         = aws_subnet.subnet_public_eks.*.id
  vpc_id          = aws_vpc.vpc-demo-eks.id
  cluster_endpoint_private_access = true

  node_groups = {
    public ={
      subnets = aws_subnet.subnet_public_eks.*.id
      desired_capacity = 2
      max_capacity = 10
      min_capacity = 2

      instance_type = var.instance_type
      source_security_group_ids = [aws_security_group.all_worker.id]
      k8s_labels = merge(var.common-tags, { Name = "${var.common-tags["Environment"]} -Route- ${var.common-tags["Project"]}" })
    }
  }
}