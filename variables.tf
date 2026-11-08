###### root/variables.tf ######

variable "aws_region" {
  description = "AWS region where the VPC, EKS cluster and workloads are deployed"
  type        = string
  default     = "us-east-1"
}
