###### root/main.tf ######

locals {
  # Unique cluster name (EKS cluster names must be unique per region).
  cluster_name = "module-eks-${random_string.suffix.result}"

  common_tags = {
    Project   = "project102"
    ManagedBy = "terraform"
  }
}

# Random suffix appended to the cluster name to avoid name collisions
# (e.g. when redeploying into the same AWS account).
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# -----------------------------------------------------------------------------
# Networking: VPC with 2 public subnets (one per AZ), an Internet Gateway
# and a public route table. Subnets are tagged for Kubernetes/EKS discovery
# so that Service type LoadBalancer provisions correctly.
# -----------------------------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                = "10.0.0.0/16"
  vpc_name                = "project102-vpc"
  public_cidrs            = ["10.0.1.0/24", "10.0.2.0/24"]
  public_sn_name          = "public-subnet"
  map_public_ip_on_launch = true
  cluster_name            = local.cluster_name
  tags                    = local.common_tags
}

# -----------------------------------------------------------------------------
# EKS: managed control plane + one managed node group running on t3.small.
# SSH access to nodes is disabled by default (see modules/eks/variables.tf).
# -----------------------------------------------------------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name            = local.cluster_name
  subnet_ids              = module.vpc.public_subnet_ids
  endpoint_public_access  = true
  endpoint_private_access = false
  public_access_cidrs     = ["0.0.0.0/0"]
  node_group_name         = "project102"
  scaling_desired_size    = 1
  scaling_min_size        = 1
  scaling_max_size        = 2
  instance_types          = ["t3.small"]
  tags                    = local.common_tags
}
