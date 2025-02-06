// modules/eks/variables.tf
variable "region" {
  type = string
  description = "AWS region"
  default = "eu-west-2"
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

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be created"
  type        = string
}
variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}
