// Update according to your VPC settings.

variable "eks_cluster_subnets" {
  description = "variable used for subnet_ids attribute"
  default = ["subnet-e866b3a5","subnet-5f767703"]
}

variable "eks_cluster_security_groups" {
  description = "variable used for security_group_ids attribute"
  default = ["sg-f8084baa"]
}

variable "eks_node_group_key_pair" {
  description = "variable used for ec2_ssh_key attribute"
  default = "myKey"
}
