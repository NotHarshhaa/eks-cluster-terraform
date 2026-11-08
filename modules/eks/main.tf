# ===========================
# IAM Role for the EKS Cluster
# ===========================

# NOTE: role names are prefixed with the cluster name because IAM role
# names are global per account; hardcoded names collide on re-deploys.
resource "aws_iam_role" "cluster" {
  name        = "${var.cluster_name}-cluster-role"
  description = "IAM role assumed by the EKS control plane"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

# ===========================
# IAM Role for Worker Nodes
# ===========================

resource "aws_iam_role" "node" {
  name        = "${var.cluster_name}-node-role"
  description = "IAM role assumed by the EKS managed node group"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

# ===========================
# EKS Cluster
# ===========================

# No custom security_group_ids are set on vpc_config: EKS then creates a
# cluster security group shared by the control plane ENIs and the worker
# nodes, which keeps control-plane <-> kubelet and pod-to-pod traffic
# working out of the box. (The previous config attached a port-80-only
# group to the control plane ENIs, which broke node management traffic.)
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.public_access_cidrs
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_controller_policy,
  ]
}

# ===========================
# EKS Managed Node Group
# ===========================

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  capacity_type   = var.capacity_type

  # SSH access to nodes is optional. When key_pair is null no
  # remote_access block is created at all. If key_pair is set but no
  # source security groups are given, port 22 is reachable from
  # 0.0.0.0/0 — restrict it via remote_access_source_security_group_ids.
  dynamic "remote_access" {
    for_each = var.key_pair != null ? [var.key_pair] : []
    content {
      ec2_ssh_key               = remote_access.value
      source_security_group_ids = var.remote_access_source_security_group_ids
    }
  }

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }

  # Replace at most one node at a time during node group upgrades.
  update_config {
    max_unavailable = 1
  }

  lifecycle {
    precondition {
      condition     = var.scaling_desired_size >= var.scaling_min_size && var.scaling_desired_size <= var.scaling_max_size
      error_message = "scaling_desired_size must be between scaling_min_size (${var.scaling_min_size}) and scaling_max_size (${var.scaling_max_size})."
    }
  }

  tags = merge(
    { Name = var.node_group_name },
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly_policy,
  ]
}
