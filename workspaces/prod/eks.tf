module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.3"

  name                         = var.cluster_name
  kubernetes_version           = var.cluster_version
  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"]
  endpoint_private_access      = true

  # enable_cluster_creator_admin_permissions = true
  enable_irsa = true


  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  create_security_group      = true
  create_node_security_group = false

  iam_role_additional_policies = {
    # AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }


  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  # security_group_additional_rules = {
  #   hybrid-node = {
  #     cidr_blocks = [local.remote_node_cidr]
  #     description = "Allow all traffic from remote node/pod network"
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "all"
  #     type        = "ingress"
  #   }

  #   hybrid-pod = {
  #     cidr_blocks = [local.remote_pod_cidr]
  #     description = "Allow all traffic from remote node/pod network"
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "all"
  #     type        = "ingress"
  #   }
  # }

  # node_security_group_additional_rules = {
  #   hybrid_node_rule = {
  #     cidr_blocks = [local.remote_node_cidr]
  #     description = "Allow all traffic from remote node/pod network"
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "all"
  #     type        = "ingress"
  #   }

  #   hybrid_pod_rule = {
  #     cidr_blocks = [local.remote_pod_cidr]
  #     description = "Allow all traffic from remote node/pod network"
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "all"
  #     type        = "ingress"
  #   }
  # }


  # remote_network_config = {
  #   remote_node_networks = {
  #     cidrs = [local.remote_node_cidr]
  #   }
  #   # Required if running webhooks on Hybrid nodes
  #   remote_pod_networks = {
  #     cidrs = [local.remote_pod_cidr]
  #   }
  # }

  # eks_managed_node_groups = {
  #   eks-workshop-9 = {
  #     instance_types           = ["t3.medium"]
  #     force_update_version     = false
  #     ami_type                 = "BOTTLEROCKET_x86_64"
  #     use_name_prefix          = false
  #     iam_role_name            = "${var.cluster_name}-ng-eks-workshop-9"
  #     iam_role_use_name_prefix = false

  #     iam_role_additional_policies = {
  #       # AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  #     }

  #     min_size     = 5
  #     max_size     = 6
  #     desired_size = 5

  #     update_config = {
  #       max_unavailable_percentage = 50
  #     }

  #     labels = {
  #       workshop-default = "yes"
  #     }
  #   }
  # }

  tags = merge(local.tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}

