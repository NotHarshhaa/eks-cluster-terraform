####### modules/eks/variables.tf #######

variable "cluster_name" {
  description = "The name of the EKS cluster (must be unique per region)"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version of the EKS control plane (e.g. `1.31`). Leave null to use the latest default supported by AWS."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EKS control plane and the node group are deployed (at least 2 AZs required)"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Enable private access to the Kubernetes API server from within the VPC"
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Enable public access to the Kubernetes API server"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public API endpoint. Restrict this to your own IPs in production instead of 0.0.0.0/0."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_group_name" {
  description = "The name of the EKS managed node group"
  type        = string
}

variable "capacity_type" {
  description = "Capacity type of the node group: `ON_DEMAND` or `SPOT`"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be either \"ON_DEMAND\" or \"SPOT\"."
  }
}

variable "instance_types" {
  description = "List of EC2 instance types for the node group (t3.medium is the comfortable minimum for EKS)"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "scaling_desired_size" {
  description = "Desired number of worker nodes in the node group"
  type        = number
  default     = 2
}

variable "scaling_min_size" {
  description = "Minimum number of worker nodes in the node group"
  type        = number
  default     = 1
}

variable "scaling_max_size" {
  description = "Maximum number of worker nodes in the node group"
  type        = number
  default     = 5
}

variable "key_pair" {
  description = "Name of an existing EC2 SSH key pair for node remote access. Leave null (default) to disable SSH access to the nodes entirely."
  type        = string
  default     = null
}

variable "remote_access_source_security_group_ids" {
  description = "Security group IDs allowed to SSH into the nodes when key_pair is set. Leave empty to allow SSH from 0.0.0.0/0 (not recommended)."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the EKS resources"
  type        = map(string)
  default     = {}
}
