// modules/eks/main.tf
resource "aws_eks_cluster" "eks" {
  name     = "spelling-eks-cluster"
  role_arn = var.role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_launch_template" "eks_node_template" {
  name_prefix   = "eks-node-template-initial" 
  image_id      = "ami-06db62431bc132602" # Replace with your desired AMI ID
  instance_type = "t3.micro" # Or your preferred instance type

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    cluster_name = aws_eks_cluster.eks.name
    region       = var.region
  }))

  # Add these if you need them:
  # key_name = var.key_name # If you want to use an SSH key
  # security_groups = [aws_security_group.worker_nodes.id] # If you have a security group resource
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name  = aws_eks_cluster.eks.name
  node_role_arn = var.node_role_arn
  subnet_ids    = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

launch_template {
  id      = aws_launch_template.eks_node_template.id
  version = aws_launch_template.eks_node_template.latest_version # Use latest_version for updates
}
}
