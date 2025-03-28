###### root/outputs.tf ######

output "cluster_id" {
  description = "The unique identifier of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "The endpoint URL for the EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "The name of the Kubernetes cluster"
  value       = module.eks.cluster_name
}

output "aws_public_subnets" {
  description = "List of public subnets created in the VPC"
  value       = module.vpc.aws_public_subnet
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}
