####### modules/eks/variables.tf #######

variable "aws_public_subnet" {
  description = "List of public subnet IDs where the EKS cluster will be deployed"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "endpoint_private_access" {
  description = "Enable or disable private access to the Kubernetes API server"
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Enable or disable public access to the Kubernetes API server"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDR blocks that can access the EKS cluster API"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_group_name" {
  description = "The name of the EKS node group"
  type        = string
}

variable "scaling_desired_size" {
  description = "Desired number of worker nodes in the EKS node group"
  type        = number
  default     = 2
}

variable "scaling_max_size" {
  description = "Maximum number of worker nodes in the EKS node group"
  type        = number
  default     = 5
}

variable "scaling_min_size" {
  description = "Minimum number of worker nodes in the EKS node group"
  type        = number
  default     = 1
}

variable "instance_types" {
  description = "List of EC2 instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "key_pair" {
  description = "Name of the SSH key pair for accessing worker nodes"
  type        = string
}
