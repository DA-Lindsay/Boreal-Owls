// modules/s3/variables.tf
variable "bucket_name" {}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be created"
  type        = string
}