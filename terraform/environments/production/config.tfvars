cidr_block                = "10.0.0.0/16"
environment               = "production"
application_instance_type = "t3.micro"
mongodb_instance_type     = "t3.micro"
public_subnets            = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets           = ["10.0.3.0/24", "10.0.4.0/24"]
keypair_path              = "./keypair/prod-project-kp.pub"
name_kp                   = "prod-project-kp"
