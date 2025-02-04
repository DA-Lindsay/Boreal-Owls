// modules/subnets/outputs.tf
output "subnet_ids" {
  value = aws_subnet.eks_subnet[*].id
}