// main.tf
provider "aws" {
  region = "eu-west-2"  # Set your preferred AWS region
  access_key = "your-access-key"   # Optional: Use if not using environment variables or credentials file
  secret_key = "your-secret-key"   # Optional: Use if not using environment variables or credentials file
}

module "vpc" {
  source = "./modules/vpc"
}

module "subnets" {
  source    = "./modules/subnets"
  vpc_id    = module.vpc.vpc_id
}

module "eks" {
  source     = "./modules/eks"
  subnet_ids = module.subnets.subnet_ids
  role_arn = module.iam.eks_role_arn
  node_role_arn = module.iam.eks_node_role_arn
}

module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "spelling-app-data"
}

module "database" {
  source = "./modules/database"
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "dynamodb_users_table_arn" {
  value = module.database.users_table_arn
}

output "dynamodb_test_results_table_arn" {
  value = module.database.test_results_table_arn
}

// outputs.tf
output "eks_cluster_id" {
  value = module.eks.eks_cluster_id
}