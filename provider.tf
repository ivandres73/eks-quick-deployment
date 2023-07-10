resource "aws_iam_openid_connect_provider" "default" {
  url = data.tls_certificate.eks_openid_connect.url

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = data.tls_certificate.eks_openid_connect.certificates[*].sha1_fingerprint
}

data "tls_certificate" "eks_openid_connect" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
