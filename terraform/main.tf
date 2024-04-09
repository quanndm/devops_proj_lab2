provider "aws" {
  region = var.region

}

# keypair
resource "aws_key_pair" "project-kp" {
  public_key = file(var.keypair_path)
  key_name   = "project-kp"
}


# network
module "network" {
  source             = "./modules/network"
  availability_zones = var.availability_zones
  cidr_block         = var.cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  environment        = var.environment
}

# security
module "security" {
  source         = "./modules/security"
  vpc_id         = module.network.vpc_id
  workstation_ip = var.workstation_ip
  environment    = var.environment
}

# mongodb
module "storage" {
  source                = "./modules/storage"
  mongodb_instance_ami  = data.aws_ami.ubuntu-ami.id
  mongodb_instance_type = var.mongodb_instance_type
  environment           = var.environment
  key_name              = aws_key_pair.project-kp.key_name
  mongodb_sg_id         = module.security.mognodb_sg_id
  mongodb_subnet_id     = module.network.private_subnets[1]
}
# application
module "application" {
  source                    = "./modules/application"
  application_subnet_id     = module.network.public_subnets[1]
  application_instance_ami  = data.aws_ami.ubuntu-ami.id
  application_instance_type = var.application_instance_type
  application_sg_id         = module.security.application_sg_id
  key_name                  = aws_key_pair.project-kp.key_name
  environment               = var.environment
}

