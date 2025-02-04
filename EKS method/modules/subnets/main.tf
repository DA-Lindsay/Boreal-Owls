// modules/subnets/main.tf
resource "aws_subnet" "eks_subnet" {
  count = 2
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(["eu-west-2a", "eu-west-2b"], count.index)
}