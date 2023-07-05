resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      "subnet-e866b3a5",
      "subnet-5f767703"
    ]
    security_group_ids = ["sg-f8084baa"]

    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  kubernetes_network_config {
    ip_family= "ipv4"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_attach
  ]
}

resource "aws_eks_addon" "vpc_cni_addon" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
  addon_version = "v1.12.6-eksbuild.2"
}

/// must deploy after having node groups
# resource "aws_eks_addon" "coredns_addon" {
#   cluster_name = aws_eks_cluster.eks_cluster.name
#   addon_name   = "coredns"
#   addon_version = "v1.10.1-eksbuild.1"
# }

# resource "aws_eks_addon" "kube_proxy_addon" {
#   cluster_name = aws_eks_cluster.eks_cluster.name
#   addon_name   = "kube-proxy"
#   addon_version = "v1.27.1-eksbuild12"
# }

resource "aws_eks_node_group" "eks_node_role" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "group1"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = ["subnet-e866b3a5", "subnet-5f767703"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  capacity_type = "SPOT"
  instance_types = ["t3.micro"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy_attach
  ]
}
