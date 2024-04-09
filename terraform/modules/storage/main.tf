resource "aws_instance" "mongodb-instance" {
  ami                    = var.mongodb_instance_ami
  instance_type          = var.mongodb_instance_type
  vpc_security_group_ids = [var.mongodb_sg_id]
  key_name               = var.key_name
  subnet_id              = var.mongodb_subnet_id

  root_block_device {
    volume_size = 10
    encrypted   = true
  }

  user_data = filebase64("${path.module}/install.sh")
  tags = {
    Name = "mongodb-instance-${var.environment}"
  }
}
