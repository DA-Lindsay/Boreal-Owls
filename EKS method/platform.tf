provider "aws" {
  region = "eu-west-2"
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "eks_subnet" {
  count = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(["eu-west-2a", "eu-west-2b"], count.index)
}

resource "aws_eks_cluster" "eks" {
  name     = "spelling-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnet[*].id
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_account_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::339712754953:policy/AmazonEKSClusterPolicy"
}
