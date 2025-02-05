resource "aws_eks_cluster" "eks" {
  name     = "spelling-eks-cluster"
  role_arn = var.role_arn  # Ensure this is set correctly

  vpc_config {
    subnet_ids = var.subnet_ids
    vpc_id     = var.vpc_id
  }
}

resource "aws_launch_template" "eks_node_template" {
  name_prefix   = "eks-node-template-initial" 
  image_id      = "ami-06db62431bc132602"
  instance_type = "t3.micro"

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    CLUSTER_NAME = aws_eks_cluster.eks.name
    region       = var.region
  }))
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

  depends_on = [aws_eks_cluster.eks] # Ensure IAM and cluster exist before nodes

  launch_template {
    id      = aws_launch_template.eks_node_template.id
    version = aws_launch_template.eks_node_template.latest_version
  }
}
