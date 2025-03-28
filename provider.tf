###### root/provider.tf ######

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# Fetch EKS Cluster Information
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# Kubernetes Provider Configuration
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Generate a Random Suffix for Unique Naming
resource "random_string" "suffix" {
  length  = 5
  special = false
}
