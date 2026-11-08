####### modules/vpc/variables.tf #######

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "instance_tenancy" {
  description = "Tenancy option for instances launched in the VPC (`default` or `dedicated`)"
  type        = string
  default     = "default"
}

variable "public_cidrs" {
  description = "List of CIDR blocks for the public subnets. One subnet is created per CIDR, spread across Availability Zones."
  type        = list(string)
}

variable "public_sn_name" {
  description = "Name prefix for the public subnets (`-1`, `-2`, ... is appended per subnet)"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether instances launched in the public subnets receive a public IPv4 address"
  type        = bool
  default     = true
}

variable "rt_route_cidr_block" {
  description = "Destination CIDR for the default route through the Internet Gateway"
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_table_name" {
  description = "Name tag for the public route table"
  type        = string
  default     = "eks-public-route-table"
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
  default     = "eks-internet-gateway"
}

variable "cluster_name" {
  description = "Name of the EKS cluster the VPC belongs to. Adds the `kubernetes.io/cluster/<name>` discovery tag to subnets so load balancers can be provisioned. Leave null if the VPC is not used with EKS."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
