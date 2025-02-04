// modules/vpc/outputs.tf
output "vpc_id" { # Important: Output the vpc_id so subnets can reference it.
  value = aws_vpc.eks_vpc.id
}