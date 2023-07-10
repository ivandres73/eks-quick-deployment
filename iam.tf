//////  CLUSTER PERMISSIONS

resource "aws_iam_role" "eks_cluster_role" {
  name        = "eksClusterRole"
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
    name      = "eksClusterRole",
    createdBy = "Ivan"
  }
}

data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attach" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = data.aws_iam_policy.AmazonEKSClusterPolicy.arn
}

////// NODES PERMISSIONS

resource "aws_iam_role" "eks_node_role" {
  name = "eks_node_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

// allows access to EKS info
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

// allows IP change of the EC2
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

// allows pulling images from AWS-ECR
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}
