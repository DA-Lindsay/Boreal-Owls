// modules/subnets/main.tf
resource "aws_subnet" "public_a" {
  vpc_id                  = module.vpc.vpc_id # Reference the vpc_id output from the vpc module
  cidr_block              = "10.0.1.0/24"  # A subnet within the VPC's CIDR range
  availability_zone = "eu-west-2a"
  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = module.vpc.vpc_id # Reference the vpc_id output from the vpc module
  cidr_block              = "10.0.2.0/24"  # Another subnet within the VPC's CIDR range
  availability_zone = "eu-west-2b"
  tags = {
    Name = "public-subnet-b"
  }
}