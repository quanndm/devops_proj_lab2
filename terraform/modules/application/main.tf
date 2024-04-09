resource "aws_iam_role" "ec2_role" {
  name = "EC2_SSM_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2_SSM_Instance_Profile"

  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "application-instance" {
  ami                         = var.application_instance_ami
  instance_type               = var.application_instance_type
  vpc_security_group_ids      = [var.application_sg_id]
  key_name                    = var.key_name
  subnet_id                   = var.application_subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name


  root_block_device {
    volume_size = 10
    encrypted   = true
  }

  user_data = filebase64("${path.module}/install.sh")

  tags = {
    Name = "application-instance-${var.environment}"
  }
}

