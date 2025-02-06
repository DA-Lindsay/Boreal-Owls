// main.tf
provider "aws" {
  region = "eu-west-2"  
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"  
}

module "subnets" {
  source    = "./modules/subnets"
  vpc_id    = module.vpc.vpc_id  
}

module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id  
  cluster_name = "spelling-app-cluster" 
  subnet_ids = module.subnets.subnet_ids
  role_arn   = module.iam.eks_role_arn
  node_role_arn = module.iam.eks_node_role_arn
  region     = module.eks.var.region 
  }

module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source      = "./modules/s3"
  vpc_id      = module.vpc.vpc_id
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
