// modules/vpc/outputs.tf
output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}