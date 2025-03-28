###### modules/vpc/variables.tf ######

# VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Allowed Access IP (Optional)
variable "access_ip" {
  description = "IP address allowed to access the VPC"
  type        = string
  default     = "0.0.0.0/0"
}

# Number of Public Subnets
variable "public_sn_count" {
  description = "Number of public subnets to create"
  type        = number
}

# List of Public Subnet CIDR Blocks
variable "public_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

# Instance Tenancy
variable "instance_tenancy" {
  description = "Tenancy option for instances launched in the VPC"
  type        = string
  default     = "default"
}

# Resource Tags
variable "tags" {
  description = "Tags to assign to resources"
  type        = string
}

# Enable Public IP for Subnets
variable "map_public_ip_on_launch" {
  description = "Whether to enable public IP assignment on public subnets"
  type        = bool
  default     = true
}

# CIDR Block for Default Route Table
variable "rt_route_cidr_block" {
  description = "CIDR block for default route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "project102-route-table"
}

variable "public_sn_name" {
  description = "The name prefix for public subnets"
  type        = string
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
  default     = "project102-igw"
}

# Variable for VPC Name
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}
