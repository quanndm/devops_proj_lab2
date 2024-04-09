cidr_block                = "10.10.0.0/16"
environment               = "staging"
application_instance_type = "t2.micro"
mongodb_instance_type     = "t2.micro"
public_subnets            = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnets           = ["10.10.3.0/24", "10.10.4.0/24"]
