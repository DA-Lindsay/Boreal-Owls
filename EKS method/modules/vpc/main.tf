// modules/vpc/main.tf
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}
