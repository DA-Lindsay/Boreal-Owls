// modules/iam/outputs.tf
output "eks_role_arn" {
  value = aws_iam_role.eks_role.arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  value       = aws_iam_role.eks_node_role.arn
}
