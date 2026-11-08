####### modules/vpc/main.tf #######

locals {
  # Tag subnets with the cluster identity so Kubernetes/EKS can discover
  # them when provisioning load balancers (Service type LoadBalancer,
  # AWS Load Balancer Controller, etc.). Empty until a cluster name is set.
  cluster_discovery_tags = var.cluster_name == null ? {} : {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# -----------------------------------------------------------------------------
# VPC. DNS support/hostnames are required by EKS (the control plane and
# the AWS Load Balancer Controller rely on them).
# -----------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = var.vpc_name },
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = var.igw_name },
    var.tags
  )
}

# -----------------------------------------------------------------------------
# Public subnets, spread across Availability Zones. The subnet count is
# derived from public_cidrs, so the CIDR list is the single source of truth.
# -----------------------------------------------------------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = length(var.public_cidrs)
}

resource "aws_subnet" "public" {
  count = length(var.public_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = random_shuffle.az_list.result[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  # kubernetes.io/role/elb marks this as an internet-facing load balancer
  # subnet; without these tags the LoadBalancer Service may stay in
  # "pending" because the controller cannot find suitable subnets.
  tags = merge(
    { Name = "${var.public_sn_name}-${count.index + 1}" },
    var.tags,
    local.cluster_discovery_tags,
    { "kubernetes.io/role/elb" = "1" }
  )

  lifecycle {
    precondition {
      condition     = length(var.public_cidrs) <= length(data.aws_availability_zones.available.names)
      error_message = "The number of public CIDRs exceeds the number of Availability Zones available in this region."
    }
  }
}

# -----------------------------------------------------------------------------
# Routing: reuse the VPC's default route table for the public subnets.
# -----------------------------------------------------------------------------
resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block = var.rt_route_cidr_block
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    { Name = var.route_table_name },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_default_route_table.public.id
}
