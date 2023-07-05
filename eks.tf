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
    aws_iam_role_policy_attachment.eks_cluster_role_attach,
    //aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_addon" "vpc_cni_addon" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
  addon_version = "v1.12.6-eksbuild.2"
}

resource "aws_eks_addon" "coredns_addon" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
  addon_version = "v1.10.1-eksbuild.1"
}

resource "aws_eks_addon" "kube_proxy_addon" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
  addon_version = "v1.27.1-eksbuild12"
}

output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}