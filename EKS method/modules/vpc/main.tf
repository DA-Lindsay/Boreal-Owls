resource "aws_vpc" "eks-vpc" {  
  cidr_block = var.cidr_block

  tags = {
    Name = "eks-vpc"
  }
}