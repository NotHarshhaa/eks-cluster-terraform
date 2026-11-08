###### root/outputs.tf ######

output "cluster_name" {
  description = "Name of the EKS cluster (also used by `aws eks update-kubeconfig`)"
  value       = module.eks.cluster_name
}

output "cluster_id" {
  description = "The unique identifier of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "The API server endpoint of the EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data of the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "vpc_id" {
  description = "The ID of the VPC hosting the cluster"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs created in the VPC"
  value       = module.vpc.public_subnet_ids
}

output "configure_kubectl" {
  description = "Run this command to configure kubectl for the deployed cluster"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}
