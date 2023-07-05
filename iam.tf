resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"
  description = "Amazon EKS - Cluster role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    name = "eksClusterRole",
    createdBy = "Ivan"
  }
}

data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role-attach" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = data.aws_iam_policy.AmazonEKSClusterPolicy.arn
}