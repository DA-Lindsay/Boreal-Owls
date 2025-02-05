// modules/eks/outputs.tf
output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "node_group_name" {
  value = aws_eks_node_group.eks_nodes.node_group_name
}

output "eks_cluster_id" {
  description = "EKS Cluster ID"
  value       = aws_eks_cluster.eks.id
}
