// modules/eks/main.tf
resource "aws_eks_cluster" "eks" {
  name     = "spelling-eks-cluster"
  role_arn = var.role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name  = aws_eks_cluster.eks.name
  node_role_arn = var.node_role_arn
  subnet_ids    = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.micro"]
}
