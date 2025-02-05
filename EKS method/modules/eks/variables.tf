// modules/eks/variables.tf
variable "region" {
  type = string
  description = "AWS region"
}

variable "subnet_ids" {
  type = list(string)
  description = "List of subnet IDs"
}

variable "role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS node group"
  type        = string
}