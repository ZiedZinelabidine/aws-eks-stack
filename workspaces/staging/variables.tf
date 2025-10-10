variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-workshop"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,39}$", var.cluster_name))
    error_message = "The cluster name must start with a letter, contain only alphanumeric characters and hyphens, and be between 2 and 40 characters long."
  }
}

variable "cluster_version" {
  description = "EKS cluster version."
  type        = string
  default     = "1.33"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+$", var.cluster_version))
    error_message = "The cluster version must be in the format 'X.Y' (e.g., '1.33')."
  }
}

variable "ami_release_version" {
  description = "Default EKS AMI release version for node groups"
  type        = string
  default     = "1.33.0-20250704"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+-[0-9]+$", var.ami_release_version))
    error_message = "The AMI release version must be in the format 'X.Y.Z-YYYYMMDD' (e.g., '1.33.0-20250704')."
  }
}

variable "vpc_cidr" {
  description = "Defines the CIDR block used on Amazon VPC created for Amazon EKS."
  type        = string
  default     = "10.42.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0)) && can(cidrnetmask(var.vpc_cidr))
    error_message = "The VPC CIDR must be a valid CIDR block (e.g., '10.42.0.0/16')."
  }
}

variable "remote_network_cidr" {
  description = "Defines the remote CIDR blocks used on Amazon VPC created for Amazon EKS Hybrid Nodes."
  type        = string
  default     = "10.52.0.0/16"

  validation {
    condition     = can(cidrhost(var.remote_network_cidr, 0)) && can(cidrnetmask(var.remote_network_cidr))
    error_message = "The remote network CIDR must be a valid CIDR block (e.g., '10.52.0.0/16')."
  }
}

variable "remote_pod_cidr" {
  description = "Defines the remote CIDR blocks used on Amazon VPC created for Amazon EKS Hybrid Nodes."
  type        = string
  default     = "10.53.0.0/16"

  validation {
    condition     = can(cidrhost(var.remote_pod_cidr, 0)) && can(cidrnetmask(var.remote_pod_cidr))
    error_message = "The remote pod CIDR must be a valid CIDR block (e.g., '10.53.0.0/16')."
  }
}
