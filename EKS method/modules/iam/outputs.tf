// modules/iam/outputs.tf
output "eks_role_arn" {
  value = aws_iam_role.eks_role.arn
}