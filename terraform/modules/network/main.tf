module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name = "storybooks-${var.environment}-vpc"
  cidr = var.cidr_block

  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_vpn_gateway = false
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
    Name = "storybooks-${var.environment}-vpc"
  }
}


