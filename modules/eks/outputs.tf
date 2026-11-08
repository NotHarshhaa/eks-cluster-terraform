####### modules/eks/outputs.tf #######

output "cluster_id" {
  description = "The unique ID of the EKS cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The API server endpoint of the EKS control plane"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data of the EKS cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}
