locals {
  remote_node_cidr = var.remote_network_cidr
  remote_pod_cidr  = var.remote_pod_cidr

  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 3, k + 3)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 3, k)]
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    created-by = "Admin"
    env        = var.cluster_name
  }

}
