// modules/subnets/outputs.tf
output "subnet_ids" { # Output the subnet IDs so EKS can use them.
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}