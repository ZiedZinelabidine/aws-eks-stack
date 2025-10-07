
# module "eks_blueprints_addons" {
#   source  = "aws-ia/eks-blueprints-addons/aws"
#   version = "~> 1.0" #ensure to update this to the latest/desired version

#   cluster_name      = module.eks.cluster_name
#   cluster_endpoint  = module.eks.cluster_endpoint
#   cluster_version   = module.eks.cluster_version
#   oidc_provider_arn = module.eks.oidc_provider_arn

#   eks_addons = {
#     aws-ebs-csi-driver = {
#       most_recent              = true
#       service_account_role_arn = aws_iam_role.ebs_csi.arn
#     }
#     coredns = {
#       most_recent = true
#     }
#     vpc-cni = {
#       before_compute = true
#       most_recent    = true
#       configuration_values = jsonencode({
#         env = {
#           ENABLE_POD_ENI                    = "true"
#           ENABLE_PREFIX_DELEGATION          = "true"
#           POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
#         }
#         nodeAgent = {
#           enablePolicyEventLogs = "true"
#         }
#         enableNetworkPolicy = "true"
#       })
#     }
#     kube-proxy = {
#       most_recent = true
#     }

#     # eks-pod-identity-agent = {
#     #   most_recent = true

#     # }
#   }

#   enable_aws_load_balancer_controller = true
#   aws_load_balancer_controller = {
#     set = [
#       {
#         name  = "vpcId"
#         value = module.vpc.vpc_id
#       },
#       {
#         name  = "podDisruptionBudget.maxUnavailable"
#         value = 1
#       },
#       {
#         name  = "resources.requests.cpu"
#         value = 0.5
#       },
#       {
#         name  = "resources.requests.memory"
#         value = 128
#       },
#       {
#         name  = "enableServiceMutatorWebhook"
#         value = "false"
#       }
#     ]
#   }

#   # enable_external_dns            = true
#   # external_dns_route53_zone_arns = ["*"]
#   # external_dns = {
#   #   create_role     = true
#   #   hosted_zone_ids = ["Z07155913UJE3ZNTALZSZ"] # Remplacez par l'ID de votre zone hébergée Route 53
#   #   domain_filters  = ["itgalaxy.io"]           # Filtre de domaine pour ExternalDNS
#   #   policy          = "sync"                    # Politique de synchronisation
#   # }



#   enable_secrets_store_csi_driver = true

#   secrets_store_csi_driver = {
#     set = [
#       {
#         name  = "syncSecret.enabled"
#         value = "true"
#       },
#       {
#         name  = "enableSecretRotation"
#         value = "true"
#     }]
#   }

#   enable_secrets_store_csi_driver_provider_aws = true
#   enable_metrics_server                        = true

#   # enable_argocd = true
#   # argocd = {
#   #   name          = "argocd"
#   #   chart_version = "8.5.3"
#   #   namespace     = "argocd"
#   #   values = [
#   #     file("values/values-argocd.yaml")
#   # ] }

#   # enable_cluster_proportional_autoscaler = true
#   # enable_karpenter                       = true
#   # enable_kube_prometheus_stack           = true
#   # enable_external_dns                    = true
#   # enable_cert_manager                    = true
#   # cert_manager_route53_hosted_zone_arns  = ["arn:aws:route53:::hostedzone/XXXXXXXXXXXXX"]

#   tags = {
#     Environment = "production"
#   }
# }

# # resource "kubernetes_namespace" "argocd" {
# #   metadata {
# #     name = "argocd" # Nom du namespace à créer
# #     labels = {
# #       env = "production" # Optionnel : Ajouter des labels
# #     }
# #     annotations = {
# #       "example.com/annotation" = "valeur" # Optionnel : Ajouter des annotations
# #     }
# #   }
# # }

# # resource "helm_release" "argocd-image-updater" {
# #   name       = "argocd-image-updater"
# #   repository = "https://argoproj.github.io/argo-helm"
# #   chart      = "argocd-image-updater"
# #   namespace  = "argocd"
# #   version    = "0.12.3"
# #   values = [
# #     file("values/values-argocd-image-updater.yaml")
# #   ]
# # }


# data "aws_iam_policy_document" "ebs_csi_irsa" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = [module.eks.oidc_provider_arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${module.eks.oidc_provider}:sub"

#       values = [
#         "system:serviceaccount:kube-system:ebs-csi-controller-sa"
#       ]
#     }

#     effect = "Allow"
#   }
# }

# resource "aws_iam_role" "ebs_csi" {
#   name               = "ebs-csi"
#   assume_role_policy = data.aws_iam_policy_document.ebs_csi_irsa.json
# }

# resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#   role       = aws_iam_role.ebs_csi.name
# }


# # 1. Créer un document de politique IAM pour le rôle IAM
# data "aws_iam_policy_document" "catalog_irsa" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = [module.eks.oidc_provider_arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${module.eks.oidc_provider}:sub"

#       values = [
#         "system:serviceaccount:default:catalog" # ServiceAccount `catalog` dans le namespace `default`
#       ]
#     }

#     effect = "Allow"
#   }
# }

# # 2. Créer le rôle IAM
# resource "aws_iam_role" "catalog" {
#   name               = "catalog-irsa-role"
#   assume_role_policy = data.aws_iam_policy_document.catalog_irsa.json
# }

# # 3. Attacher la politique pour accéder à AWS Secrets Manager
# resource "aws_iam_role_policy_attachment" "catalog_secrets_manager" {
#   role       = aws_iam_role.catalog.name
#   policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite" # Politique pour accéder à Secrets Manager
# }


